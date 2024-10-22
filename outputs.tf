output "lambda_function_arn" {
  value = module.apigw_lambda_module.lambda_function_arn_list
}

output "api_gateway_url" {
  value = module.apigw_lambda_module.api_path
}
