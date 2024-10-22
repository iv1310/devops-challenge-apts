# Create a policy document for iam role
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    effect = "Allow"
  }
}

# IAM Role for lambda
resource "aws_iam_role" "lambda_iam_role" {
  name               = substr("lambda_${var.lambda_project_name}", 0, 64)
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  tags = merge({
    module = "apigw_lambda"
  }, var.tags, var.default_tags)
}

# Create a policy document for lambda
data "aws_iam_policy_document" "lambda_logging_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]

    effect = "Allow"
  }
}

# IAM Role Policy to allow lambda to write logs to CloudWatch logs
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_${var.lambda_project_name}"
  role   = aws_iam_role.lambda_iam_role.name
  policy = data.aws_iam_policy_document.lambda_logging_policy.json
}

# Lambda additional policy if any
resource "aws_iam_role_policy" "lambda_iam_role_additional_policy" {
  count  = var.lambda_policy_enabled ? 1 : 0
  name   = "lambda_${var.lambda_project_name}_additional"
  role   = aws_iam_role.lambda_iam_role.name
  policy = var.lambda_policy
}
