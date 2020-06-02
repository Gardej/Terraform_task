Exam Task

Goal: 
  - Use one of configuration management tools (CloudFormation or Terraform) to create a template of a stack with the required resources.
  - Publish your work results to a separate repository at https://git.epam.com with the all required steps and commands to:
	configure AWS access;
	deploy stacks;
	run 2 or more tools from a list, which you could find at the end of this task.
  - Be ready for code review.

Required resources:
  - S3 Bucket.
  - Lambda function, which will generate files and store them on S3 bucket.
  - EC2 instance(s) with access to S3 bucket.

Template expectations:
  - it should be possible to run template multiple times, creating isolated environments;
  - it should be possible to create more than 5 environments.

Lambda expectations:
  - triggered every 15 minutes;
  - creates an S3 object with name equal to date in "yyyyMMdd-HH" format. The content of the object should be the current number of minutes.

S3 bucket expectations:
  - it should not keep files older than 3 days;
  - it should be possible to restore accidentally deleted objects;
  - it should not be available to public/unauthorized users.

EC2 instance expectations:
  - it should be a part of AutoScaling group;
  - number of instances should increase if their average CPU load increases;
  - it should have possibility to list and download S3 bucket objects;
  - it should not have possibility to delete or overwrite S3 bucket objects;
  - no AWS credentials should be stored at EC2 instance itself.

List of static code analysis/security assessment tools:
a.	https://github.com/Yelp/detect-secrets - detecting secrets in code;
b.	https://github.com/bridgecrewio/checkov/ - static code analysis for terraform/cloudformation;
c.	https://github.com/toniblyx/prowler - CIS AWS benchmark;
d.	https://github.com/toniblyx/my-arsenal-of-aws-security-tools - list of AWS security tools;
e.	https://github.com/shuaibiyy/awesome-terraform - list of terraform resources.
