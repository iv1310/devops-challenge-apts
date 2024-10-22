resource "aws_lambda_function" "this" {
  function_name                  = var.lambda_project_name
  filename                       = var.lambda_filename
  role                           = aws_iam_role.lambda_iam_role.arn
  handler                        = var.lambda_handler
  runtime                        = var.lambda_runtime
  memory_size                    = var.lambda_memory_size
  timeout                        = var.lambda_timeout
  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions
  source_code_hash               = filebase64sha256(var.lambda_filename)
  tags = merge({
    module = "apigw_lambda",
  }, var.tags, var.default_tags)

  environment {
    variables = var.env_variables
  }

  lifecycle {
    ignore_changes = [source_code_hash]
  }
}
