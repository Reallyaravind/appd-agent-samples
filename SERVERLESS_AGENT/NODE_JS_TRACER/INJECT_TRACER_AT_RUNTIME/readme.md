# AppDynamics Node.js Tracer – Inject Tracer at Runtime

## Overview
- Demonstrates how to instrument an **AWS Lambda Node.js function** with the AppDynamics Serverless Node.js Tracer by injecting the tracer at runtime using the **AppDynamics AWS Lambda Extension** (no code changes required to the function handler).
- Uses **Terraform** to provision the Lambda function, IAM execution role, CloudWatch log group, and the AppDynamics Lambda Extension layer along with the required AppDynamics environment variables.
- Sends trace data to the AppDynamics Controller for end-to-end observability of serverless Node.js workloads.

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites
- An active **AppDynamics SaaS Controller** account with valid credentials (Account Name, Access Key, Controller Host).
- **AWS account** with permissions to create Lambda functions, IAM roles, and CloudWatch log groups.
- **Terraform** installed and configured locally.

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **`main.tf`** – Terraform configuration that provisions the AWS Lambda function, IAM execution role, CloudWatch log group, attaches the AppDynamics AWS Lambda Extension layer, and injects all required AppDynamics environment variables to enable runtime tracer instrumentation.
2. **`app/index.js`** – Sample Node.js Lambda handler that contains plain business logic with **no AppDynamics SDK imports or code changes** — instrumentation is injected automatically at runtime by the AppDynamics Lambda Extension.
3. **`app/package.json`** – Defines the Node.js Lambda application metadata and dependencies.

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
- **Verify the agent is running:** look for `AppDynamics initialized` in CloudWatch logs, and confirm the tier/node appears in the AppDynamics Controller UI under your configured Application.

## Official Documentation

- [AppDynamics Serverless APM for AWS Lambda](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.5.0/install-app-server-agents/serverless-apm-for-aws-lambda)
- [Configure Environment Variables](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.5.0/install-app-server-agents/serverless-apm-for-aws-lambda/set-up-the-serverless-apm-environment/configure-environment-variables)
- [AppDynamics AWS Lambda Extension to Instrument Serverless APM at Runtime](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.5.0/install-app-server-agents/serverless-apm-for-aws-lambda/use-the-appdynamics-aws-lambda-extension-to-instrument-serverless-apm-at-runtime)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.