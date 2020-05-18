provider "aws" {
  region = "${var.aws_region_name}" 
}

# S3 configuration
resource "aws_s3_bucket" "my_bucket" {
  bucket = "bucket-hardzeyeu-${var.aws_env_name}" 
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = 3
    }
  }
}

# Lambda configuration
resource "aws_lambda_function" "my_lambda" {
  filename            = "function.zip"
  function_name       = "lambda-${var.aws_env_name}"
  role                = "arn:aws:iam::695473938047:role/S3_FullAccess_Role"
  handler             = "lambda.lambda_handler"
  runtime             = "python3.7"

  environment {
    variables         = {
      BACKET          = "bucket-hardzeyeu-${var.aws_env_name}"
    }
  }

  tracing_config {
    mode              = "PassThrough"
  }
}

resource "aws_cloudwatch_event_rule" "every_fifteen_minutes" {
  name                = "every_15_minutes_lambda-${var.aws_env_name}"
  description         = "Fires every fifteen minutes"
  schedule_expression = "rate(15 minutes)"
}

resource "aws_cloudwatch_event_target" "my_lambda_every_fifteen_minutes" {
  rule                = "${aws_cloudwatch_event_rule.every_fifteen_minutes.name}"
  arn                 = "${aws_lambda_function.my_lambda.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_my_lambda" {
  statement_id        = "AllowExecutionFromCloudWatch"
  action              = "lambda:InvokeFunction"
  function_name       = "${aws_lambda_function.my_lambda.function_name}"
  principal           = "events.amazonaws.com"
  source_arn          = "${aws_cloudwatch_event_rule.every_fifteen_minutes.arn}"
}

# VPC configuration
resource "aws_vpc" "default" {
  cidr_block              = "10.0.0.0/16"

  tags = {
    Name = "${var.aws_env_name}"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "gw" {
  vpc_id                  = "${aws_vpc.default.id}"
}

resource "aws_route_table" "rt" {
  vpc_id                  = "${aws_vpc.default.id}"

  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = "${aws_internet_gateway.gw.id}"
    }
}

resource "aws_route_table_association" "rt-assoc" {
  subnet_id               = "${aws_subnet.main.id}"
  route_table_id          = "${aws_route_table.rt.id}"
}

resource "aws_security_group" "allow_ssh" {
  name                    = "sg_allow_ssh-${var.aws_env_name}"
  description             = "Allow ssh inbound traffic"
  vpc_id                  = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 configuration
data "aws_ami" "ubuntu" {
  most_recent        = true

  filter {
    name             = "name"
    values           = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }
  owners             = ["099720109477"]
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "iam-role-${var.aws_env_name}"
  description        = "EC2 can list and get S3 objects"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ec2_s3_access_policy" { 
  name               = "iam-policy-${var.aws_env_name}"
  path               = "/"
  description        = "EC2 can list and get S3 objects"

  policy             = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "${aws_s3_bucket.my_bucket.arn}"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.my_bucket.arn}/*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "attachment" {
  name               = "iam_policy_attachment-${var.aws_env_name}"
  roles              = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn         = "${aws_iam_policy.ec2_s3_access_policy.arn}"
}

resource "aws_iam_instance_profile" "profile" {
  name               = "iam_instance_profile-${var.aws_env_name}"
  role               = "${aws_iam_role.ec2_s3_access_role.name}"
}

# Launch configuration and autoscaling
resource "aws_launch_configuration" "l_conf" {
  name                      = "ubuntu_config-${var.aws_env_name}"
  image_id                  = "${data.aws_ami.ubuntu.id}"
  key_name                  = "${var.aws_key_for_region}"
  security_groups           = ["${aws_security_group.allow_ssh.id}"]
  instance_type             = "t2.micro"
  iam_instance_profile      = "${aws_iam_instance_profile.profile.name}"
  root_block_device {
    encrypted               = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "asg-${var.aws_env_name}"
  vpc_zone_identifier       = ["${aws_subnet.main.id}"]
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  default_cooldown          = 300
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.l_conf.name}"
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tags = [
    {
      key                   = "Name"
      value                 = "${var.aws_env_name}"
      propagate_at_launch   = true
    }
  ]
}

resource "aws_autoscaling_policy" "cpu_policy" {
  name                      = "cpu_policy-${var.aws_env_name}"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = "${aws_autoscaling_group.asg.name}"
  estimated_instance_warmup = 200
  
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}