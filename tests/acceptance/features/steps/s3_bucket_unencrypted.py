import logging
import os
import time
import uuid

import boto3
from behave import *  # pylint: disable=wildcard-import, unused-wildcard-import
from reflex_acceptance_common import ReflexAcceptance

S3_CLIENT = boto3.client("s3")
SQS_CLIENT = boto3.client("sqs")
acceptance_client = ReflexAcceptance("s3-bucket-not-encrypted")


def create_bucket():
    """Handles s3-bucket-not-encrypted, s3-logging-not-enabled, s3-bucket-policy-public-access."""
    bucket_name = f"reflex-acceptance-{uuid.uuid4()}"
    create_response = S3_CLIENT.create_bucket(Bucket=bucket_name)
    logging.info("Created instance with response: %s", create_response)
    return bucket_name


def delete_bucket(bucket_name):
    delete_response = S3_CLIENT.delete_bucket(Bucket=bucket_name)
    logging.info("Deleted bucket with: %s", delete_response)


def get_message_from_queue(queue_url):
    time.sleep(100)
    message = SQS_CLIENT.receive_message(QueueUrl=queue_url, WaitTimeSeconds=20)
    message_body = message["Messages"][0]["Body"]
    return message_body


@given("the Reflex s3-bucket-not-encrypted rule is deployed into an AWS account")
def step_impl(context):
    assert acceptance_client.get_queue_url_count("S3BucketNotEncrypted-DLQ") == 1
    assert acceptance_client.get_queue_url_count("S3BucketNotEncrypted") == 2
    assert acceptance_client.get_queue_url_count("test-queue") == 1
    sqs_test_response = SQS_CLIENT.list_queues(QueueNamePrefix="test-queue")
    context.config.userdata["test_queue_url"] = sqs_test_response["QueueUrls"][0]


@when("an S3 bucket is created without encryption")
def step_impl(context):
    bucket_name = create_bucket()
    context.config.userdata["bucket_name"] = bucket_name


@then("a Reflex alert message is sent to our Reflex SNS topic")
def step_impl(context):
    message = get_message_from_queue(context.config.userdata["test_queue_url"])
    print(message)
    assert "unencrypted" in message
    delete_bucket(context.config.userdata["bucket_name"])
