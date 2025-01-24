variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  type        = string
}

variable "output_s3_bucket" {
  description = "Nome do bucket S3 para saída"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN da fila SQS para acionar a Lambda"
  type        = string
}

variable "client_email" {
  description = "Email do cliente para notificação"
  type        = string
}