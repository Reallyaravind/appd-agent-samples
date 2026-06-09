import json
import logging

# Set up standard logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    
    logger.info("Lambda function triggered successfully!")
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Hello World from an AppDynamics instrumented Lambda!',
            'status': 'success'
        })
    }