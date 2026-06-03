# AppDynamics PHP Agent with Machine Agent

## Overview
- Demonstrates how to instrument a PHP/Apache application with the AppDynamics PHP Agent using a **standalone Java proxy** (manual TCP-based proxy) running in its own container.
- Adds a **Machine Agent** sidecar service to enable machine-level metrics, Server Visibility (SIM), and Docker monitoring alongside the PHP node.
- Packaged with **Docker Compose** to orchestrate three services together: `appd-ma` (Machine Agent), `appd-proxy` (PHP Java proxy), and `web` (PHP/Apache app).

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Docker installed on your machine
- AppDynamics-compatible PHP agent package downloaded from the [AppDynamics Download Portal](https://accounts.appdynamics.com/downloads) and extracted into this folder as `appdynamics-php-agent-linux_x64/`

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **app/Dockerfile** - Builds the PHP/Apache base image used by the `web` service (multi-stage `builder` target referenced in compose).
2. **app/index.php** - Minimal PHP application (`Hello World`) used to generate traffic and business transactions.
3. **docker-compose.yaml** - Orchestrates three services:
   - `appd-ma` - Machine Agent with SIM and Docker monitoring enabled, reporting host/container metrics to the Controller.
   - `appd-proxy` - Standalone PHP Java proxy listening on TCP port `3000` (with port range `3001-3100`) for agent communication.
   - `web` - PHP/Apache application container that runs the AppDynamics PHP agent in **manual proxy** mode.
4. **run-with-appd-php-agent.sh** - Startup script that:
   - Waits for the `appd-proxy` TCP port to be reachable before proceeding.
   - Runs the PHP agent `install.sh` with TCP comm parameters (no auto-launch proxy).
   - Starts the application entry point (`apache2-foreground`) as PID 1.

**Quick Start Guide:**

- **Download and Extract Agent** - Place the extracted PHP agent into `./appdynamics-php-agent-linux_x64/` (matches the volume mount in `docker-compose.yaml`).

- **Configure AppDynamics Credentials** - Update all `<VALUE>` placeholders in `docker-compose.yaml` file.

- **Start the Application** - Run:
  ```bash
  docker compose up --build
  ```

- **Access the Application** - Open `http://localhost:8080/` in your browser to generate traffic and business transactions.

- **Verify the Proxy is Running** - Check that the standalone proxy started and is listening on TCP `3000`:
  ```bash
  docker compose logs -f appd-proxy
  ```

- **Verify the Agent is Running** - Inspect the web container and confirm the agent attached:
  ```bash
  docker compose logs -f web
  ```
  Then log into your AppDynamics Controller and confirm `php-machine-agent-app` / `tier1` / `node1` appears under **Applications**.

- **Verify the Machine Agent** - Check the Machine Agent container logs and confirm it has registered with the Controller:
  ```bash
  docker compose logs -f appd-ma
  ```
  Then verify in the Controller under **Servers** that the host/container is reporting metrics.

- **Enable Debug Logging** - Enable trace-level logging and collect logs for both the application (agent) and the proxy.

  For the Agent:
   1. Go to `<php_agent_root>/php/conf`
   2. Edit `appdynamics_agent_log4cxx.xml`
   3. Change the logging level value from `Info` to `trace`

  For the Proxy:
   1. Go to `<php_agent_root>/proxy/conf/logging`
   2. Edit `log4j.xml`
   3. Change the logging level from `info` to `trace`

  Then restart the containers and apply load for 5–10 minutes:

   ```bash
   docker compose restart appd-proxy
   docker compose restart web
   ```

- **View Agent Logs** - PHP agent logs are written inside the `web` container at `/opt/appdynamics/php-agent/logs/`.

  
## Official Documentation

- [Install the PHP Agent](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/php-agent/install-the-php-agent)
- [PHP Agent Configuration Properties](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/php-agent/php-agent-configuration-settings)
- [Machine Agent with PHP Node](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/php-agent/install-the-php-agent/using-a-machine-agent-on-a-php-node)
- [PHP Supported Environments](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/php-agent/php-supported-environments)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.