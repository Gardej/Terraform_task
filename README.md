# Description how to set-up environment.

### 1. Clone this repo to your local system:
```
git clone https://github.com/Gardej/Terraform_task.git
cd Terraform_task/
git checkout first_review
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
### 4. Initialize terraform in current directory:
```
terraform init
```
### 5. Create an execution plan:
```
terraform plan
```
### 6. Create environment:
```
terraform apply
```
### 7. You will be asked to enter some values during the environment creation:

##### `aws_region_name`     - for example `us-east-2`
##### `aws_key_for_region`  - name of key to connect to EC2 instance (create if you don't have in region)
##### `aws_env_name`        - for example `test` or `dev` (here only lovercase letters acceptable)
##### `external_IP`         - your external IP for example `8.8.8.8` (you can determine your external-IP with https://ping.eu)

### 8. To destroy environment use following command (make sure s3 bucket is empty):
```
terraform destroy
```
### 9. To create one more environment make steps 1-7 in other directory.
 

