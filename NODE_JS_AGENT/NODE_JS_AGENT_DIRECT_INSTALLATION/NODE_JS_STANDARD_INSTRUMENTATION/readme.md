# AppDynamics Node.js Agent Standard Instrumentation

## Overview
- Demonstrates basic AppDynamics Node.js agent integration using standard instrumentation
- Automatically detects and monitors business transactions for Express.js endpoints
- Simple "Hello World" application to verify agent connectivity and APM data collection

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Node.js installed on your system
- AppDynamics Controller access with valid credentials
- npm package manager available
- Port 3000 available for the application

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **package.json** - Defines project dependencies including the AppDynamics agent and Express framework
2. **index.js** - Main application file that initializes the AppDynamics agent with controller configuration and sets up Express routes for `/` and `/hello` endpoints

**Quick Start Guide:**

- **Install Node.js Dependencies** - Run `npm install` to download and install the required packages

- **Configure AppDynamics Credentials** - Update `index.js` with your AppDynamics controller details.

- **Enable Debug Logging** - Set the logging level to `DEBUG` in the `logging.logfiles[0].level` field and check logs in `/tmp/appd/` directory to troubleshoot and verify the agent is running

- **Run the Application** - Execute `node index.js` to start the server on port 3000

- **Verify Agent Status** - Open your browser and navigate to `http://localhost:3000/` or `http://localhost:3000/hello` to confirm the application is running, then check your AppDynamics Controller UI to see monitored business transactions and performance metrics

## Official Documentation

- [AppDynamics Node.js Agent Installation](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/nodejs-agent/install-the-nodejs-agent)
- [Node.js Agent Configuration](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/nodejs-agent/nodejs-agent-configuration-properties)
- [Node.js Supported Environments](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/nodejs-agent/nodejs-supported-environments)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.