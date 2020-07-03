Feature: This tests the detective mechanism for when a bucket in S3 is created without encryption
  Scenario: A bucket is created without encryption.
    Given the Reflex s3-bucket-not-encrypted rule is deployed into an AWS account
    When an S3 bucket is created without encryption
    Then a Reflex alert message is sent to our Reflex SNS topic
