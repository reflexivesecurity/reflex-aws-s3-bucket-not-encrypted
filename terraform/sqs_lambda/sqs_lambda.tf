module "sqs_lambda" {
  source = "git::https://github.com/reflexivesecurity/reflex-engine.git//modules/sqs_lambda?ref=v2.1.1"

  cloudwatch_event_rule_id  = var.cloudwatch_event_rule_id
  cloudwatch_event_rule_arn = var.cloudwatch_event_rule_arn
  function_name             = "S3BucketNotEncrypted"
  package_location          = var.package_location
  handler                   = "s3_bucket_not_encrypted.lambda_handler"
  lambda_runtime            = "python3.7"
  environment_variable_map = {
    SNS_TOPIC = var.sns_topic_arn,
    MODE      = var.mode
  }
  custom_lambda_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetEncryptionConfiguration",
        "s3:PutEncryptionConfiguration"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF



  queue_name    = "S3BucketNotEncrypted"
  delay_seconds = 60

  target_id = "S3BucketNotEncrypted"

  sns_topic_arn  = var.sns_topic_arn
  sqs_kms_key_id = var.reflex_kms_key_id
}
