provider "aws" {
  region     = "ap-southeast-2"
  access_key = "<VALUE>"
  secret_key = "<VALUE>"
}

# 1. Archive the Node.js application source code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/app"
  output_path = "${path.module}/app.zip"
}

locals {
  aws_region         = "ap-southeast-2"
  appd_extension_ver = "30"
  appd_api_endpoints = {
    "us-west-2"      = "pdx-sls-agent-api.saas.appdynamics.com"
    "eu-central-1"   = "fra-sls-agent-api.saas.appdynamics.com"
    "ap-southeast-2" = "syd-sls-agent-api.saas.appdynamics.com"
  }
}

# 2. IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "appdynamics_lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 3. AWS Lambda Function Configuration
resource "aws_lambda_function" "node_app" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  function_name = "APPD_LAMBDA_TRACER"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "nodejs20.x"
  handler       = "appdynamics-lambda-nodejs-tracer.handler"

  layers = [
    "arn:aws:lambda:${local.aws_region}:338050622354:layer:appdynamics-lambda-extension:${local.appd_extension_ver}"
  ]

  environment {
    variables = {

      APPDYNAMICS_ACCOUNT_NAME               = "<VALUE>"
      APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY   = "<VALUE>"
      APPDYNAMICS_APPLICATION_LAMBDA_HANDLER = "index.handler"
      APPDYNAMICS_APPLICATION_NAME           = "<VALUE>"
      APPDYNAMICS_CONTROLLER_HOST            = "<VALUE>"
      APPDYNAMICS_CONTROLLER_PORT            = "<VALUE>"
      APPDYNAMICS_CONTROLLER_SSL_ENABLED     = "<VALUE>"
      APPDYNAMICS_IS_ESM_ENABLE              = "false"
      APPDYNAMICS_SERVERLESS_API_ENDPOINT    = local.appd_api_endpoints[local.aws_region]
      APPDYNAMICS_TIER_NAME                  = "<VALUE>"
      APPDYNAMICS_LOG_LEVEL                   = "INFO" // Accepted Values: "DEBUG", "INFO", "WARN", "ERROR", "FATAL"
    }
  }
}