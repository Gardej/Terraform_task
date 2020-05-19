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
### 4. Initialize terraform in current directory:
```
terraform init
```
### 5. Create environment:
```
terraform apply
```
### 6. You will be asked to input some values during the environment creation:

##### `aws_region_name`     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - for example `us-east-2`
##### `aws_key_for_region`  - name of key created in region you indicated above to connect to EC2 instance
##### `aws_env_name`        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - for example *test* or *dev* (here only lovercase letters acceptable)
##### `external_IP`         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - your external IP for example *8.8.8.8* (you can determine your external-IP with https://ping.eu)

### 7. To create one more environment make steps No.1-6 in other directory.
 

