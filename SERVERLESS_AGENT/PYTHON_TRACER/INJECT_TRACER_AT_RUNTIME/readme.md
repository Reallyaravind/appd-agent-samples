# AppDynamics Python Tracer – Inject Tracer at Runtime

## Overview
- Demonstrates how to instrument an **AWS Lambda Python function** with the AppDynamics Serverless Python Tracer by **injecting the tracer at runtime** using the AppDynamics Lambda Extension layer — no application code changes required.
- Uses the `AWS_LAMBDA_EXEC_WRAPPER` environment variable pointing to `/opt/appdynamics-extension-script` to automatically wrap the Lambda handler at cold start.
- Provisioned with **Terraform**, which attaches the AppDynamics Lambda Extension layer and injects all required AppDynamics environment variables into the function.

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- An active **AppDynamics SaaS Controller** account with valid credentials (Account Name, Access Key, Controller Host).
- **AWS account** with permissions to create Lambda functions, IAM roles, and CloudWatch log groups.
- **Terraform** installed and configured locally.

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **`main.tf`** – Terraform configuration that:
   - Packages the `app/` directory into a deployment ZIP.
   - Attaches the **AppDynamics Lambda layer** (`appdynamics-lambda-extension`) which provides the tracer binaries.
   - Sets `AWS_LAMBDA_EXEC_WRAPPER=/opt/appdynamics-extension-script` so the AppDynamics wrapper auto-instruments the handler at runtime.
   - Injects AppDynamics controller, account, tier, and serverless API endpoint environment variables.
2. **`app/app.py`** – Sample Python Lambda handler (`app.lambda_handler`) that does **not** import or reference the AppDynamics tracer — instrumentation is fully transparent and injected at runtime.

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
- [Configure Environment Variables](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.5.0/install-app-server-agents/serverless-apm-for-aws-lambda/set-up-the-serverless-apm-environment/configure-environment-variables)
- [AppDynamics AWS Lambda Extension to Instrument Serverless APM at Runtime](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.5.0/install-app-server-agents/serverless-apm-for-aws-lambda/use-the-appdynamics-aws-lambda-extension-to-instrument-serverless-apm-at-runtime)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.