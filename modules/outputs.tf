output "api_path" {
  description = "api path"
  value       = "${aws_api_gateway_stage.api_gw_stage[0].invoke_url}/${var.api_gateway_resource_path}"
}

output "lambda_function_arn_list" {
  description = "The arn of the lambda function"
  value       = aws_lambda_function.this.arn
}
