# AppDynamics Python Tracer – Instrument Function Code

## Overview
- Demonstrates how to instrument an **AWS Lambda Python function** with the AppDynamics Serverless Python Tracer by modifying the function code directly.
- Uses **Terraform** to provision the Lambda function, IAM role, and required AppDynamics environment variables.
- Sends trace data to the AppDynamics Controller for end-to-end observability of serverless workloads.

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- An active **AppDynamics SaaS Controller** account with valid credentials (Account Name, Access Key, Controller Host).
- **AWS account** with permissions to create Lambda functions, IAM roles, and CloudWatch log groups.
- **Terraform** installed and configured locally.

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **`main.tf`** – Terraform configuration that provisions the AWS Lambda function, IAM execution role, log group, and injects AppDynamics environment variables.
2. **`app/app.py`** – Sample Python Lambda handler that imports the AppDynamics tracer and wraps the function handler using the `@tracer` to enable transaction monitoring.

**Quick Start Guide:**

- Update `main.tf` with your AppDynamics Controller details and AWS region.

- Initialize and apply Terraform:  
    ```bash
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
- Invoke the Lambda function to generate traces

- **Enable debug logging:** set the environment variable `APPDYNAMICS_LOGGING_LEVEL=DEBUG` in `main.tf` and re-apply.
- **View logs:** check CloudWatch Logs for tracer initialization and transaction data.
- **Verify the agent is running:** look for `AppDynamics Python tracer initialized` in CloudWatch logs, and confirm the tier/node appears in the AppDynamics Controller UI under your configured Application.

## Official Documentation

- [AppDynamics Serverless APM for AWS Lambda](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.5.0/install-app-server-agents/serverless-apm-for-aws-lambda)
- [Configure Environmental Variables](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.5.0/install-app-server-agents/serverless-apm-for-aws-lambda/set-up-the-serverless-apm-environment/configure-environment-variables)
- [Configure the Python Tracer](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.5.0/install-app-server-agents/serverless-apm-for-aws-lambda/python-serverless-tracer)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening