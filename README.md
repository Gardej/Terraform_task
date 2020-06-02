# Exam task solution:
### 0. Exam_task is attached here https://github.com/Gardej/Terraform_task/blob/master/Exam_task.md.

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
### 5. Create workspace (in "workspace_name" only lowercase letters acceptable):
```
terraform workspace new "workspace_name"
```
### 5.1 Useful commands to work with workspaces:
```
terraform workspace list
terraform workspace select "workspace_name"
terraform workspace delete "workspace_name"
```
### 6. Enter values of all necessary variables in `terraform.tfvars` file.

### 7. Create an execution plan:
```
terraform plan
```
### 8. Create environment:
```
terraform apply
```
### 9. To destroy environment use following command (make sure s3 bucket is empty):
```
terraform destroy
```
### 10. To create one more environment create additional workspace - steps 5-9.
 

