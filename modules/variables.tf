variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "lambda_project_name" {
  description = "The name of the lambda project"
  type        = string
  default     = "hello"
}

variable "lambda_filename" {
  description = "Filename of the lambda source code."
  type        = string
  default     = ""
}

variable "lambda_handler" {
  description = "The function to call in the main script name (usually: main)"
  type        = string
}

variable "lambda_runtime" {
  description = "Runtime to execute on lambda"
  type        = string
  default     = "python3.8"
}

variable "lambda_memory_size" {
  description = "The memory size given to the function"
  type        = number
  default     = 128
}

variable "lambda_timeout" {
  description = "The time allowed to the function to finish execution"
  type        = number
  default     = 30
}

variable "lambda_reserved_concurrent_executions" {
  description = "Max lambda concurrency. If set to -1, concurrency remains as default (1000)"
  type        = number
  default     = -1
}

variable "lambda_cloudwatch_logs_retention" {
  description = "The time in days retention for lambda logs"
  type        = number
  default     = 7
}

variable "api_gateway_cloudwatch_logs_retention" {
  description = "The time in days retention for lambda logs"
  type        = number
  default     = 14
}

variable "api_gateway_http_method" {
  description = "The type of authorization used for the method"
  type        = string
  default     = "ANY"
}

variable "api_gateway_authorization" {
  description = "The type of authorization used for the method"
  type        = string
  default     = "NONE"
}

variable "tags" {
  description = "The tags to apply"
  type        = map(string)
  default     = {}
}

variable "env_variables" {
  description = "Environment variables for lambda function"
  type        = map(string)
  default     = {}
}

variable "use_api_gateway" {
  description = "Do you want your lambda function be reachable/callable from api gateway?"
  type        = bool
  default     = false
}

variable "api_gateway_path" {
  description = "The path (without the /) on api gateway which redirect to the lambda function"
  type        = string
  default     = "not_defined"
}

variable "api_gateway_resource_path" {
  description = "The path on resource API"
  type        = string
  default     = ""
}

variable "api_gateway_stage_name" {
  description = "The name of the stage to be deployed."
  type        = string
  default     = ""
}

variable "apigw_cloudwatch_logs_format" {
  description = "https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html#apigateway-cloudwatch-log-formats"
  type        = string
  default     = "{ \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\",\"routeKey\":\"$context.routeKey\", \"status\":\"$context.status\",\"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\" }"
}

variable "lambda_policy" {
  description = "the additional policy for the lambda"
  type        = string
  default     = ""
}

variable "lambda_policy_enabled" {
  description = "Do you want your lambda function have a policy"
  type        = bool
  default     = false
}
