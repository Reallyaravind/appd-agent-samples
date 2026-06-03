# AppDynamics Node.js Agent - Init Container Installation

## Overview

- Uses init container approach to inject AppDynamics agent binaries into the application container
- Automatically detects and monitors Node.js business transactions running on Express.js
- Separates agent initialization from application deployment for cleaner Kubernetes architecture

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Docker installed and configured
- Kubernetes cluster running

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **app/package.json** - Defines Express.js application dependencies
2. **app/app.js** - Simple Express application with root endpoint for testing AppDynamics monitoring
3. **app/dockerfile** - Containerizes the Node.js application on port 3000
4. **init-container/dockerfile** - Builds the AppDynamics agent init container that copies agent binaries to a shared volume
5. **init-container/shim.js** - Initializes AppDynamics agent configuration and enables the agent for the application
6. **k8s/secret.yaml** - Kubernetes Secret storing sensitive AppDynamics access key credentials
7. **k8s/deployment.yaml** - Kubernetes Deployment orchestrating init container to attach agent, then runs the application
8. **k8s/service.yaml** - Kubernetes Service exposing the application on port 3000

## Quick Start Guide

1. **Build the Docker Images** - 
Create the `nodejs-app` image using the provided Dockerfile:
```sh
docker build -t nodejs-app:latest ./app
```

Build the AppDynamics agent init container image:
```sh
docker build -t appd-nodejs-agent:latest ./init-container
```

2. **Configure AppDynamics Variables**

You can provide variables in two ways:
- **Environment Variables** (Used in this application)
- **ConfigMap** 


3. **Update & Apply Kubernetes Manifests**
Update the k8s files with your controller & application credentials & 
Modify deployment file → Create Secret → Deploy application → Expose with Service.

Apply all manifests:
```sh
kubectl apply -f k8s/secret.yaml k8s/deployment.yaml k8s/service.yaml
```

4. **Generate some load on the application:**

5. **Check logs:** - View logs in `/tmp/appd` directory within the container

6. **For more detailed logs, set the log level** by adding the following environment variable to `k8s/deployment.yaml`:
```yaml
- name: APPDYNAMICS_LOGGER_LEVEL
  value: TRACE
```

## Official Documentation

- [AppDynamics Node.js Agent INIT Installation](https://help.splunk.com/en/appdynamics-on-premises/application-performance-monitoring/26.4.0/install-app-server-agents/node.js-agent/install-the-node.js-agent-in-containers/use-init-containers)
- [Node.js Agent Configuration Properties](https://help.splunk.com/en/appdynamics-on-premises/application-performance-monitoring/26.4.0/install-app-server-agents/node.js-agent/node.js-settings-reference/environment-variables)
- [Node.js Supported Environments](https://help.splunk.com/en/appdynamics-on-premises/application-performance-monitoring/26.4.0/install-app-server-agents/node.js-agent/node.js-supported-environments)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.