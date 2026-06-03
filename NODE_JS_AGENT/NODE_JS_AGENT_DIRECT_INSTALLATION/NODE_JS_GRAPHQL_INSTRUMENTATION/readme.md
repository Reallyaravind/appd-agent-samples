# AppDynamics Node.js Agent GraphQL Instrumentation

## Overview
- Demonstrates AppDynamics Node.js agent integration with Apollo Server and GraphQL
- Automatically detects and monitors GraphQL operations as Business Transactions
- Uses the `enableGraphQL: true` configuration to enable GraphQL-specific visibility and metrics

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Node.js installed on your system 
- AppDynamics Controller access with valid credentials

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **package.json** - Defines project dependencies including AppDynamics agent, Apollo Server, Express, and GraphQL
2. **index.js** - Main application file that:
   - Initializes the AppDynamics agent with controller configuration
   - Sets up Apollo Server with GraphQL schema
   - Enables GraphQL visibility with `enableGraphQL: true`
   - Defines a simple Books query endpoint

**Quick Start Guide:**

- **Install Node.js Dependencies** - Run `npm install` to download and install all required packages

- **Configure AppDynamics Credentials** - Update `index.js` with your AppDynamics controller details

- **Enable Debug Logging for troubleshooting** - Set the logging level to `TRACE` in the `logging.logfiles[0].level` field  and check logs in `/tmp/appd/` directory to troubleshoot and verify the agent is running

- **Run the Application** 

- **Test GraphQL Endpoint** - Apply load to your GraphQL endpoint to generate traffic and verify instrumentation.

- **Verify Agent Status** - Open your browser and navigate to the AppDynamics Controller UI to verify the agent is reporting data. 

- **Configure Controller for GraphQL Recognition** - Perform the steps outlined in the official documentation **[GraphQL Custom Match Rule](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/configure-instrumentation/transaction-detection-rules/custom-match-rules/node.js-business-transaction-detection/configure-graphql-custom-match-rule-for-a-node.js-application)**

- **Restart Application** - Restart the application & provide load and you will be able to see the BT in the controller.

## Official Documentation

- [AppDynamics Node.js Agent Installation](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/node.js-agent/install-the-node.js-agent)
- [GraphQL Custom Match Rules for Node.js](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/configure-instrumentation/transaction-detection-rules/custom-match-rules/node.js-business-transaction-detection/configure-graphql-custom-match-rule-for-a-node.js-application)
- [Node.js Supported Environments](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/node.js-agent/node.js-supported-environments)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.