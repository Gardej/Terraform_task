# Description how to set-up environment.

### 1. Clone this repo to your local system:
```
git clone https://github.com/Gardej/Terraform_task.git
cd Terraform_task/
```
### 2. Create zip file for lambda:
```
zip function.zip lambda.py
```
### 3. Export credentials for your aws account to environment variables:
```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```
### 4. Initialize terraform in current directory.
```
terraform init
```
### 5. Run environment:
```
terraform apply
```
### 6. You will be asked to input some values during the installation.
#### `aws_region_name`     - for example "us-east-2"
#### `aws_key_for_region`  - name of existing key to connect to EC2 instance
#### `aws_env_name`        - for example "test" or "dev" (only lovercase letters acceptable)

### 7. To create one more environment make steps 1-6 (except step 3) in other directory.
 

