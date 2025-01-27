terraform {
  backend "s3" {
    bucket         = "fiap-challenge-terraform-state"
    key            = "lambda-video-processing-challenge/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_function_name}_role"

  assume_role_policy = file("trust.json")
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.lambda_function_name}_policy"
  description = "Permissões para a Lambda acessar S3 e DynamoDB"
  policy      = file("policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  filename         = "deployment_package.zip"
  source_code_hash = filebase64sha256("deployment_package.zip")
  handler          = "app.lambda_function.lambda_handler"
  runtime          = "python3.13"
  timeout          = 900
  memory_size      = 512
  layers = [
    aws_lambda_layer_version.ffmpeg_layer.arn
  ]
  ephemeral_storage {
    size = 10240
  }

  environment {
    variables = {
      DYNAMODB_TABLE_NAME  = var.dynamodb_table_name
      OUTPUT_S3_BUCKET     = var.output_s3_bucket
      SES_SOURCE_EMAIL     = var.ses_source_email
    }
  }
}

resource "aws_lambda_layer_version" "ffmpeg_layer" {
  layer_name          = "ffmpeg-layer"
  description         = "FFmpeg static binary layer"
  compatible_runtimes = ["python3.9", "python3.10", "python3.11", "python3.12", "python3.13"]

  s3_bucket = var.bucket_name_ffmpeg
  s3_key    = var.object_key_ffmpeg
}

resource "aws_lambda_event_source_mapping" "sqs_event_source" {
  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.lambda_function.arn
  batch_size       = 5
}