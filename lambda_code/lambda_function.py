import logging
import json
import redis
from datetime import datetime

# Configure logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    logger.info("Received event: %s", event)
    s3_event = event["Records"][0]["s3"]
    bucket_name = s3_event["bucket"]["name"]
    object_key = s3_event["object"]["key"]

    logger.info("Received file in bucket: %s, file name: %s", bucket_name, object_key)

    # Extract file name and creation timestamp
    file_name = object_key.split("/")[-1]
      
    creation_timestamp = datetime.utcnow().isoformat()
    data = {file_name: creation_timestamp}
    json_data = json.dumps(data)
    print(f"Metadata written to ElastiCache: {data}")

    # Write to ElastiCache (Redis) with key:value pair
    redis_endpoint = "test-redis-cluster.jklmh8.0001.aps1.cache.amazonaws.com"  # Replace with your Redis endpoint
    redis_client = redis.StrictRedis(host=redis_endpoint, port=6379, decode_responses=True)
    
    print(f"Connect to ElastiCache: {redis_client}")

    redis_key = f"{file_name}:{creation_timestamp}"
    print(f"redis key: {redis_key}")
    redis_value = json.dumps({"FileName": file_name, "CreationTimestamp": str(creation_timestamp)})
    print(f"redis value: {redis_value}")
    
    expiration_time_in_seconds = 900
    redis_client.setex(redis_key,expiration_time_in_seconds, redis_value)
    print(f"Data stored in Redis cache. Key: {redis_key}, Value: {redis_value}")
    

    
    return {"statusCode": 200, "body": "File processed successfully"}
