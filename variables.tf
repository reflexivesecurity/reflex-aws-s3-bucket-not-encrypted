variable "email" {
  description = "Email of administrator for notifications"
  type        = string
}

variable "sns_topic_arn" { 
  description = "SNS topic arn of central or local sns topic"
  type        = string
}
