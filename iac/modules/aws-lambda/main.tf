resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  inline_policy {
    name = "${var.project_code}-function-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["logs:Create*", "logs:Put*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_lambda_function" "function" {
  depends_on    = [aws_iam_role.iam_for_lambda]

  filename      = var.function_code_filename
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.function_handler

  source_code_hash = filebase64sha256(var.function_code_filename)

  runtime = var.function_runtime

  environment {
    variables = {
      project_code = var.project_code
      purpose = var.purpose
      environment = "AWS"
    }
  }
}