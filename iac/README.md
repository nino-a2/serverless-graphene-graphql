terraform init -backend-config=backend.conf
terraform apply -var-file=defaults.tfvars --auto-approve -var account_id=`aws sts get-caller-identity --query "Account" | tr -d '"'`