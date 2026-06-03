# AppDynamics Python Agent Auto Proxy

## Overview
- Here we are using agent auto proxy to instrument a Python application.
- The agent with auto proxy automatically detects Business Transaction monitoring for particular endpoints.
- Python agent requires Java proxy to be run which communicates with the controller. In this application, the proxy will start automatically.

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Install the agent by either pip method or download from the downloads portal
- Install Docker (optional) & Python versions compatible with the agent version installed

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **requirements.txt** - Installs Flask, Gunicorn, and AppDynamics Python agent
2. **appdynamics.cfg** - Configuration file with Controller credentials and application settings
3. **run.sh** - Launches the Python agent which auto-starts the Java proxy, then starts the application
4. **Dockerfile** - Packages everything into a container running on port 8002
5. **app.py** - Simple Flask application with endpoints for monitoring

## Quick Start Guide

- **Configure AppDynamics Credentials** - Update `appdynamics.cfg` with your credentials & details

**Choose one of the following options to run the application:**
- **Install Python Dependencies** - Run `pip install -r requirements.txt` if running locally without Docker
    **then**
- **Run Locally with Agent** - Execute `./run.sh` to start application & proxy  
    *or*
- **Build Docker Image** - Run `docker build -t python-agent-auto-proxy .` to create the container image  
    **then**
- **Run with Docker** - Execute `docker run -it --rm -p 8002:8002 python-agent-auto-proxy` to start the containerized application

- **Access the Application** - Open `http://localhost:8002/home` in your browser to test the application
- **View Metrics in Controller** - Log into AppDynamics Controller, navigate to Applications, and check the Business Transactions section for detected endpoints

- **Enable Debug Mode** - Set `level = DEBUG` and `debugging = true` in `appdynamics.cfg` if you need to troubleshoot issues. Post this modification, restart agent & application. You will be able to see the logs in `/tmp/appd`
- **Verify Agent Status** - Confirm if the Java proxy started automatically with the agent by `ps -aef | grep java`

## Official Documentation

- [Install Agent](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/python-agent/install-the-python-agent/install-the-agent)
- [Instrument Application](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/python-agent/install-the-python-agent/instrument-the-application)
- [Configure Agent](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/python-agent/install-the-python-agent/configure-the-agent)
- [Supported Environments](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/python-agent/python-supported-environments)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.









Here we are using agent auto proxy to instrument a python appliation.

Overview

- The agent with auto proxy automatically detects Business transaction monitoring for particular endpoints.
- Python agent requires java proxy to be run which communicates with the controller. Here in this application, the proxy will start automatically.
- Note: These steps serve as a reference and may change with upcoming agent releases. Always consult the official documentation before proceeding.

Prerequsite.
- install the agent by either pip method or download from the downloads portal
- Install Docker(optional) & python versions compatible with the agent version installed.


installation method / explaination of code.
- give very simple small gist of the code
Official documentation

install agent-> https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/python-agent/install-the-python-agent/install-the-agent

Instrument application -> https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/python-agent/install-the-python-agent/instrument-the-application
Configure agent -> https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/python-agent/install-the-python-agent/configure-the-agent

supported environments-> https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/python-agent/python-supported-environments


support

- If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.
