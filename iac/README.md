# Prequisites
Before you deploy this project, you must have an S3 bucket to store the terraform state. Similarly, make sure to update the values in 'iac/backend.conf' according to your needs.

# 1. Requirements
If not done yet, first prepare the Python code as defined in 'src/README.md'.

## 1.1 Global (option)
If you installed the requirements defined in 'src/README.md' globally:
  - Just zip the content main.py
  - Likely, (didn't test), you would have to include Flask and Graphene in the zip as well. See section 1.2 for more info.

## 1.2 Virtualenv (option)
If you installed the requirements defined in 'src/README.md' in a virtualenv:
  - zip the contents:
    - main.py, AND
    - the contents in *"your virtualenv name"*/Lib/site-packages/ (e.g. the contents would be located in venv/Lib/site-packages/
      - this folder contains the dependencies: Flask and Graphene  

# Initialize your terraform project
Run:
`terraform init -backend-config=backend.conf`

# Deploy the terraform project
Run:
```
terraform apply -var-file=defaults.tfvars --auto-approve -var account_id=`aws sts get-caller-identity --query "Account" | tr -d '"'`
```
