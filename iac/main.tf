terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {}
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

module "lambda_function" {
  source                  = "./modules/aws-lambda"

  function_code_filename  = var.function_code_filename
  function_handler        = var.function_handler
  function_name           = var.function_name
  function_runtime        = var.function_runtime
  project_code            = var.project_code
  purpose                 = var.purpose
}

module "api_gateway" {
  source                  = "./modules/aws-api-gateway"
  depends_on              = [module.lambda_function]

  account_id              = var.account_id
  aws_region              = var.aws_region
  function_code_filename  = var.function_code_filename
  function_invoke_arn     = module.lambda_function.function_invoke_arn
  function_name           = var.function_name
  project_code            = var.project_code
}