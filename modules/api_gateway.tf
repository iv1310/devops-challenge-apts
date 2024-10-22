resource "aws_api_gateway_rest_api" "api_gw_rest_api" {
  count       = var.use_api_gateway ? 1 : 0
  name        = "${var.lambda_project_name}_api"
  description = "API Gateway REST Api for ${var.lambda_project_name}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = merge({
    module = "apigw_lambda"
  }, var.tags, var.default_tags)
}

# Create a resource for the API
resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.api_gw_rest_api[0].id
  parent_id   = aws_api_gateway_rest_api.api_gw_rest_api[0].root_resource_id
  path_part   = var.api_gateway_resource_path
}

resource "aws_api_gateway_method" "proxy" {
  count         = var.use_api_gateway ? 1 : 0
  rest_api_id   = aws_api_gateway_rest_api.api_gw_rest_api[0].id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = var.api_gateway_http_method
  authorization = var.api_gateway_authorization
}

resource "aws_api_gateway_integration" "lambda_integration" {
  count       = var.use_api_gateway ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.api_gw_rest_api[0].id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.proxy[0].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.this.invoke_arn
}

resource "aws_api_gateway_deployment" "api_gw_deployment" {
  count       = var.use_api_gateway ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.api_gw_rest_api[0].id

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.api_gw_rest_api[0].id,
      var.api_gateway_http_method,
      aws_api_gateway_integration.lambda_integration[0].id,
      aws_api_gateway_method.proxy[0].request_models,
      aws_api_gateway_method.proxy[0].request_validator_id,
    ]))
  }

  depends_on = [aws_api_gateway_integration.lambda_integration]
}

resource "aws_api_gateway_stage" "api_gw_stage" {
  count         = var.use_api_gateway ? 1 : 0
  deployment_id = aws_api_gateway_deployment.api_gw_deployment[0].id
  rest_api_id   = aws_api_gateway_rest_api.api_gw_rest_api[0].id
  stage_name    = var.api_gateway_stage_name

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_aws_cloudwatch_log_group.arn
    format          = var.apigw_cloudwatch_logs_format
  }

  depends_on = [aws_cloudwatch_log_group.api_gateway_aws_cloudwatch_log_group]

  tags = merge({
    module = "apigw_lambda"
  }, var.tags, var.default_tags)
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  count         = var.use_api_gateway ? 1 : 0
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_gw_rest_api[0].execution_arn}/*/*"
}
