module "cwe" {
  source      = "git::https://github.com/cloudmitigator/reflex-engine.git//modules/cwe?ref=multi-account"
  name        = "S3BucketNotEncrypted"
  description = "Rule to enforce S3 bucket encryption"

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

}
