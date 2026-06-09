import appdynamics
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

@appdynamics.tracer
def lambda_handler(event, context):
    logger.info("Lambda function triggered by AppDynamics tracer.")

    # Your "Hello World" response
    return {
        "statusCode": 200,
        "body": "Hello World from AppDynamics Instrumented Lambda!",
    }