# AppDynamics Node.js Agent - Cluster Auto Instrumentation

## Overview
- Uses Kubernetes Cluster Agent for automatic instrumentation of Node.js applications without modifying deployment manifests
- Cluster Agent automatically injects the AppDynamics Node.js agent into pods matching specified criteria
- Enables centralized agent management and monitoring across multiple namespaces in a Kubernetes cluster

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Kubernetes cluster running (this setup uses **minikube**)
- Docker installed for building container images
- AppDynamics Cluster Agent operator file downloaded from the AppDynamics Downloads portal (placed as `cluster-agent-operator.yaml`)

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **cluster-agent-operator.yaml** - Deploys the AppDynamics Operator and Cluster Agent infrastructure, including custom resource definitions (CRDs), service accounts, and RBAC roles. Download this from the AppDynamics Downloads portal and place it in this directory.
2. **cluster-agent.yaml** - Defines the `Clusteragent` resource that orchestrates automatic instrumentation for Node.js apps in specified namespaces, including instrumentation rules and the Node.js agent image to inject
3. **Makefile** - Automation script that handles image loading, namespace creation, secret creation, cluster agent setup, app build, deployment, and cleanup
4. **node-js-app/Dockerfile** - Containerizes the Node.js application on port 3000
5. **node-js-app/package.json** - Defines application dependencies (Express.js framework)
6. **node-js-app/index.js** - Simple Express.js application with endpoints for testing
7. **k8s/app.yaml** - Kubernetes Deployment and Service for the Node.js application

**Quick Start Guide:**

- **Set Configuration Values** - Update the following files with your AppDynamics controller & application details:
  - `cluster-agent.yaml` — set `controllerUrl`, `account`, and the `tierName` under `instrumentationRules`
  - `Makefile` — set `CONTROLLER_KEY` and `ACCESS_KEY`

- **Run Automated Setup** - Execute `make all` to perform all setup steps (loads images, creates namespaces, creates secrets, deploys the cluster operator and cluster agent, builds the app image, and deploys the application)

- **Verify Cluster Agent Deployment** - Run `make get-pods` to check if all pods are running in both the `appdynamics` and `dev` namespaces

- **Enable Debug Logging** - Set `logLevel: "TRACE"` in `cluster-agent.yaml` to capture detailed cluster agent and instrumentation logs

- **View Agent Logs** - Check logs with `make logs` or `kubectl logs -f deployment/nodejs-app -n dev` to monitor agent initialization and application behavior

- **Verify Agent is Running** - Open your browser and navigate to `http://localhost:3000/` (or the minikube service URL) to generate traffic, then check the AppDynamics Controller UI to confirm the application appears with monitored business transactions

- **Generate Application Load** - Access the application multiple times to generate transactions: `curl http://localhost:3000/` and `curl http://localhost:3000/hello`

- **Monitor in Controller** - Log into your AppDynamics Controller and verify that the application `nodejs-auto-ins` (as configured by `defaultAppName` in `cluster-agent.yaml`) appears with automatic instrumentation enabled

- **Clean Up Resources** - Run `make clean` to delete the `dev` and `appdynamics` namespaces and all associated resources when finished

## Official Documentation

- [AppDynamics Cluster Agent Auto instrumentation](https://help.splunk.com/en/appdynamics-on-premises/application-performance-monitoring/26.4.0/install-app-server-agents/node.js-agent/install-the-node.js-agent-in-containers/use-auto-instrumentation)
- [Node.js Agent Configuration Properties](https://help.splunk.com/en/appdynamics-on-premises/application-performance-monitoring/26.4.0/install-app-server-agents/node.js-agent/node.js-settings-reference/environment-variables)
- [Node.js Supported Environments](https://help.splunk.com/en/appdynamics-on-premises/application-performance-monitoring/26.4.0/install-app-server-agents/node.js-agent/node.js-supported-environments)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.