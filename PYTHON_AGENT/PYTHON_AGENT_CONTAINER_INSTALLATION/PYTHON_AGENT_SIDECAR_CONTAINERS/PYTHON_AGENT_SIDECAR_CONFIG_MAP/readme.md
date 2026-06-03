# Python Agent APM - Sidecar Container Installation

Here we are using a sidecar container-based approach to instrument a Python application.

## Overview

- We use the sidecar container approach to instrument and detect the Python application.
- The agent automatically detects business transaction monitoring for particular endpoints.

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Install the agent by either the pip method or download from the downloads portal.
- Install Docker (optional) and Python versions compatible with the agent version installed.
- Kubernetes cluster access and `kubectl` configured.
- AppDynamics controller credentials and access key.

## Installation Method / Code Explanation

### Simple Overview of the Code

1. **requirements.txt** - Installs Flask & other dependencies
4. **Dockerfile** - Packages everything into a docker image.
3. **app.py** - Simple Flask application with endpoints for monitoring
4. **configmap.yaml** - Kubernetes ConfigMap for storing AppDynamics configuration
5. **secret.yaml** - Kubernetes Secret for storing sensitive AppDynamics credentials
6. **deployment.yaml** - Kubernetes Deployment configuration for running the Python agent in containers
7. **service.yaml** - Kubernetes Service to expose the application on port 8080

### Quick Start Guide

1. **Build the Docker image:** Create the `sidecar-python-app` image using the provided Dockerfile.
2. **Configure AppDynamics variables:** You can provide variables in two ways:
    - **Environment Variables** 
    - **ConfigMap** (used in this application)
3. **Update Configmap: & deployment.yaml** Edit `k8s/configmap.yaml` & `k8s/deployement.yaml` with your AppDynamics controller details.
4. **Update Secret:** Edit `k8s/secret.yaml` with your access key.
5. **Build the Docker image:**
    ```sh
    docker build -t sidecar-python-app .
    ```
6. **Apply Kubernetes manifests:**
    - Create ConfigMap → Create Secret → Build Docker image → Deploy application → Expose with Service.
    - Apply all manifests:
      ```sh
      kubectl apply -f k8s/configmap.yaml k8s/secret.yaml k8s/deployment.yaml k8s/service.yaml
      ```
7. **Verify deployment and logs:**
    - Generate some load on the application.
    - Check deployment logs:
      ```sh
      kubectl logs -f deployment/mypython-app -c mypython-app
      ```
    - You can also exec into the container to find logs in `/tmp/appd`.
    - For more detailed logs, set the log level by adding the following environment variable:
      ```yaml
      - name: APPDYNAMICS_LOGGING_LEVEL
        value: TRACE
      ```

## Official Documentation

- **Install Agent:** [Splunk AppDynamics Python Agent Installation](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/python-agent/install-the-python-agent-in-containers/deploy-the-dynamic-languages-proxy)

- **Agent Settings:** [Python Agent Settings](https://help.splunk.com/en/appdynamics-on-premises/application-performance-monitoring/26.4.0/install-app-server-agents/python-agent/python-agent-settings)

- **Supported Environments:** [Python Agent Supported Environments](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/python-agent/python-supported-environments)

## Support

If you encounter any issues with the AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.
