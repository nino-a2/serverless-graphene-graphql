resource "aws_api_gateway_rest_api" "api" {
  name        = var.project_code
  description = "The API Gateay API"
}

resource "aws_api_gateway_resource" "resource" {
  depends_on  = [aws_api_gateway_rest_api.api]

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "graphql"
}

resource "aws_api_gateway_method" "method" {
  depends_on        = [aws_api_gateway_resource.resource]

  rest_api_id       = aws_api_gateway_rest_api.api.id
  resource_id       = aws_api_gateway_resource.resource.id
  http_method       = "POST"
  authorization     = "NONE"
  api_key_required  = true
}

resource "aws_api_gateway_integration" "integration" {
  depends_on  = [aws_api_gateway_method.method]

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.function_invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on      = [aws_api_gateway_rest_api.api]

  rest_api_id     = aws_api_gateway_rest_api.api.id

  triggers        = {
    redeployment  = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  depends_on    = [aws_api_gateway_deployment.deployment]

  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "v1"
}

resource "aws_api_gateway_api_key" "key" {
  name = var.project_code
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  depends_on  = [aws_api_gateway_stage.stage]

  name        = var.project_code

  api_stages {
    api_id    = aws_api_gateway_rest_api.api.id
    stage     = aws_api_gateway_stage.stage.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
  depends_on    = [
    aws_api_gateway_api_key.key,
    aws_api_gateway_usage_plan.usage_plan
  ]

  key_id        = aws_api_gateway_api_key.key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}

resource "aws_lambda_permission" "apigw_lambda" {
  depends_on = [aws_api_gateway_method.method]

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}