provider "aws" {
  region = "us-east-1"
}

module "enforce_s3_encryption" {
  source           = "git@github.com:cloudmitigator/reflex.git//modules/cwe_lambda?ref=v0.0.1"
  rule_name        = "EnforceS3Encryption"
  rule_description = "Rule to enforce S3 bucket encryption"

  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "source": [
    "aws.s3"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "CreateBucket",
      "DeleteBucketEncryption"
    ]
  }
}
PATTERN

  function_name            = "EnforceS3Encryption"
  source_code_dir          = "${path.module}/source"
  handler                  = "s3_encryption.lambda_handler"
  lambda_runtime           = "python3.7"
  environment_variable_map = { SNS_TOPIC = module.enforce_s3_encryption.sns_topic_arn }
  custom_lambda_policy     = <<EOF
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



  queue_name    = "EnforceS3Encryption"
  delay_seconds = 60

  target_id = "EnforceS3Encryption"

  topic_name = "EnforceS3Encryption"
  email      = var.email
}
