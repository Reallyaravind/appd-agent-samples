# AppDynamics Node.js Agent - Docker File Instrumentation

## Overview
- Demonstrates AppDynamics Node.js agent integration using Docker containerization with a locally unzipped agent package
- Automatically detects and monitors business transactions for Express.js endpoints
- Shows how to copy a pre-downloaded AppDynamics agent into the Docker image for containerized deployments

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Docker installed on your system
- AppDynamics Node.js agent package downloaded and unzipped

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **package.json** - Defines Express.js application dependencies (note: AppDynamics is NOT listed as it's copied directly)
2. **index.js** - Main application file that initializes the AppDynamics agent with controller configuration and sets up Express routes for `/` and `/hello` endpoints
3. **dockerfile** - Containerizes the Node.js application on port 3000
4. **appdynamics/** - Folder containing the pre-downloaded and unzipped AppDynamics Node.js agent package

**Quick Start Guide:**

- **Download AppDynamics Agent** - Download the Node.js agent from the [AppDynamics Download Portal](https://accounts.appdynamics.com/downloads) and unzip it into the `appdynamics/` folder in this directory

- **Update AppDynamics Credentials** - Edit `index.js` and replace placeholder values with your controller hostname, port, account name, and account access key

- **Build the Docker Image** - Run: `docker build -t nodejs-agent-app:latest .`

- **Run the Container** - Execute: `docker run -it --rm -p 3000:3000 nodejs-agent-app:latest`

- **Enable Debug Logging** - Set the logging level to `TRACE` in `index.js` under `logging.logfiles[0].level` to enable debug output

- **View Logs** - Check logs in the `/tmp/appd/` directory inside the running container.

- **Test the Application** - Navigate to `http://localhost:3000/` or `http://localhost:3000/hello` in your browser to verify the application is running

- **Check if Agent is Running** - Log into your AppDynamics Controller UI and verify the application appears in the Applications section with active business transactions being monitored

## Official Documentation

- [AppDynamics Node.js Agent Installation](https://help.splunk.com/en/appdynamics-on-premises/application-performance-monitoring/26.4.0/install-app-server-agents/node.js-agent/install-the-node.js-agent-in-containers/use-a-dockerfile)
- [Node.js Agent Configuration Properties](https://help.splunk.com/en/appdynamics-on-premises/application-performance-monitoring/26.4.0/install-app-server-agents/node.js-agent/node.js-settings-reference/general-settings)
- [Node.js Supported Environments](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/node.js-agent/node.js-supported-environments)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.