variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
  default     = "LambdaProcessadorVideos"
}

variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  type        = string
  default     = "tabela_videos"
}

variable "output_s3_bucket" {
  description = "Nome do bucket S3 para saída"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN da fila SQS para acionar a Lambda"
  type        = string
  default     = "arn:aws:sqs:us-east-1:123456789012:fila_videos"
}

variable "client_email" {
  description = "Email do cliente para notificação"
  type        = string
  default     = "otavio.sto@gmail.com"
}