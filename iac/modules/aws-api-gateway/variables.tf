variable "account_id" {
  description = "The Account ID."
  type        = string
}

variable "aws_region" {
  description = "The region in which the AWS resources should be created."
  type        = string
}

variable "function_code_filename" {
  description = "The path and filename of the file containing the function code."
  type        = string
}

variable "function_invoke_arn" {
  description = "The ARN to invoke the Lambda Function."
  type        = string
}

variable "function_name" {
  description = "The name of the Lambda Function."
  type        = string
}

variable "project_code" {
  description = "The project code."
  type        = string
}