# Description how to set-up environment.

### 1. Clone this repo to your local system:
```
git clone https://github.com/Gardej/Terraform_task.git
cd Terraform_task/
```
### 2. Type "terraform init" in directory with files.

### 3. Export AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to environment variables.

### 4. To apply this environment it is also necessary to input some values:
#### - "aws_region_name"     # For example "us-east-2"
#### - "aws_key_for_region"  # Here indicate existing key to connect to EC2 instance
#### - "aws_env_name"        # For example "test" or "dev" !!! lovercase only acceptable !!!

### 5. There are two ways to do this:
#### - indicate default values in "variables.tf" file
#### - input values during "terraform apply"

### 6. Type "terraform apply" in directory with files.

### 7. To create one more environment make steps 1-7 (except step 3) in other directory.
 

