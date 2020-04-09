""" Module for enforcing S3EncryptionRule """

import json
import os

import boto3
from reflex_core import AWSRule


class S3EncryptionRule(AWSRule):
    """ AWS rule for ensuring S3 bucket encryption """

    client = boto3.client("s3")

    def __init__(self, event):
        super().__init__(event)

    def extract_event_data(self, event):
        """ To be implemented by every rule """
        self.raw_event = event
        self.bucket_name = event["detail"]["requestParameters"]["bucketName"]

    def resource_compliant(self):
        return self.bucket_encrypted()

    def remediate(self):
        self.encrypt_bucket()

    def bucket_encrypted(self):
        """ Returns True if the bucket is encrypted, False otherwise """
        try:
            self.client.get_bucket_encryption(Bucket=self.bucket_name)
            return True
        except Exception:
            return False

    def encrypt_bucket(self):
        """ Encrypt the S3 bucket """
        self.client.put_bucket_encryption(
            Bucket=self.bucket_name,
            ServerSideEncryptionConfiguration={
                "Rules": [
                    {"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}},
                ]
            },
        )

    def get_remediation_message(self):
        """ Returns a message about the remediation action that occurred """
        message = f"The S3 bucket {self.bucket_name} was unencrypted. "
        if self.should_remediate():
            message += "AES-256 encryption was enabled."

        return message


def lambda_handler(event, _):
    """ Handles the incoming event """
    print(event)
    s3_rule = S3EncryptionRule(json.loads(event["Records"][0]["body"]))
    s3_rule.run_compliance_rule()
