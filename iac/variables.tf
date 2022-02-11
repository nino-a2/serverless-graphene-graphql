variable "account_id" {
  description = "The AWS Account in which the resources should be deployed."
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

variable "function_handler" {
  description = "The name of the Function handler."
  type        = string
}

variable "function_name" {
  description = "The name of the Function."
  type        = string
}

variable "function_runtime" {
  description = "the runtime of the Function."
  type        = string
}

variable "project_code" {
  description = "The project code."
  type        = string
}

variable "purpose" {
  description = "The purpose of this project."
  type        = string
}