import boto3
from datetime import datetime, timezone
import os


def lambda_handler(event, context):

    bucket_name = os.environ['BACKET']

    x = datetime.now(timezone.utc)
    string = x.strftime("%H:%M")
    encoded_string = string.encode("utf-8")
    s3_path = x.strftime("%Y%m%d-%H")

    s3 = boto3.resource("s3")
    s3.Bucket(bucket_name).put_object(Key=s3_path, Body=encoded_string)

