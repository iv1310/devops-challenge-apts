module "apigw_lambda_module" {
  source = "./modules" # Adjust this path to the actual path of your module

  # Lambda-specific variables
  lambda_project_name   = "simple-http-logs"
  lambda_filename       = "./lambda_function.zip"          # Path to your zipped Lambda function
  lambda_handler        = "lambda_function.lambda_handler" # Python handler name
  lambda_runtime        = "python3.8"                      # Python runtime
  lambda_memory_size    = 128                              # Adjust memory size as per requirement
  lambda_timeout        = 30                               # Lambda timeout in seconds
  lambda_policy_enabled = false                            # Enable this if you want additional policies

  # API Gateway configuration
  use_api_gateway              = true
  api_gateway_resource_path    = "data"
  api_gateway_http_method      = "ANY"
  api_gateway_stage_name       = "test"
  apigw_cloudwatch_logs_format = "{ \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\",\"routeKey\":\"$context.routeKey\", \"resourcePath\":\"$context.resourcePath\", \"status\":\"$context.status\",\"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\", \"error_message\": \"$context.error.messageString\" }"

  # Tags (optional)
  default_tags = {
    environment = "test"
  }
}
