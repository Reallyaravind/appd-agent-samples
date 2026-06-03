# AppDynamics PHP Agent with Shared Standalone Proxy

## Overview
- Demonstrates how to instrument **multiple PHP/Apache application containers** with the AppDynamics PHP Agent using a **single shared standalone Java proxy** running in its own container.
- Each PHP application container runs the PHP agent in **manual proxy mode** and connects to the shared `appd-proxy`, reporting to its **own AppDynamics Business Application**.
- Packaged with **Docker Compose** to orchestrate three services together: `appd-proxy` (shared PHP Java proxy), `web` (PHP/Apache app #1), and `webnew` (PHP/Apache app #2).

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Docker installed on your machine
- AppDynamics-compatible PHP agent package downloaded from the [AppDynamics Download Portal](https://accounts.appdynamics.com/downloads) and extracted into this folder as `appdynamics-php-agent-linux_x64/`

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **app/Dockerfile** - Builds the PHP/Apache base image used by both PHP services (multi-stage `builder` target referenced in compose).
2. **app/index.php** - Minimal PHP application (`Hello World`) used to generate traffic and business transactions.
3. **docker-compose.yaml** - Orchestrates three services:
   - `appd-proxy` - Standalone PHP Java proxy listening on TCP port `3000` (with port range `3001-3100`) for agent communication. Shared by all PHP app containers.
   - `web` - PHP/Apache application container reporting to AppDynamics business application `php-shared-agent1-app` via the shared proxy.
   - `webnew` - PHP/Apache application container reporting to AppDynamics business application `php-shared-agent2-app` via the same shared proxy.
4. **run-with-appd-php-agent.sh** - Startup script that:
   - Waits for the `appd-proxy` TCP port to be reachable before proceeding.
   - Runs the PHP agent `install.sh` with TCP comm parameters (no auto-launch proxy).
   - Starts the application entry point.

**Quick Start Guide:**

- **Download and Extract Agent** - Place the extracted PHP agent into `./appdynamics-php-agent-linux_x64/` (matches the volume mount in `docker-compose.yaml`).

- **Configure AppDynamics Credentials** - Update all `<VALUE>` placeholders in `docker-compose.yaml` for **every service** (`appd-proxy`, `web`, `webnew`). Each web container can target its own application name; tier and node names can also be customized.

- **Start the Application** - Run:
  ```bash
  docker compose up --build
  ```

- **Access the Applications** - Open the following URLs in your browser to generate traffic and business transactions for each app:
  - `http://localhost:8080/` &rarr; `web` (reports to `php-shared-agent1-app`)
  - `http://localhost:8081/` &rarr; `webnew` (reports to `php-shared-agent2-app`)

- **Verify the Shared Proxy is Running** - Check that the standalone proxy started and is listening on TCP `3000`:
  ```bash
  docker compose logs -f appd-proxy
  ```

- **Verify the Agents are Running** - Inspect each web container and confirm the agent attached and connected to the shared proxy:
  ```bash
  docker compose logs -f web
  docker compose logs -f webnew
  ```
  Then log into your AppDynamics Controller and confirm both applications (`php-shared-agent1-app` and `php-shared-agent2-app`) appear under **Applications**, each with their respective `tier1` / `node1`.

- **Enable Debug Logging** - Enable trace-level logging and collect logs for both the application (agent) and the shared proxy.

  For the Agent (applies to both `web` and `webnew`):
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
   docker compose restart webnew
   ```

- **View Agent Logs** - PHP agent logs are written inside each web container at `/opt/appdynamics/php-agent/logs/`.

  
## Official Documentation

- [Install the PHP Agent](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/php-agent/install-the-php-agent)
- [PHP Agent Configuration Properties](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/php-agent/php-agent-configuration-settings)
- [Shared Proxy Setup](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/php-agent/install-the-php-agent/use-a-shared-proxy-for-php-agents)
- [PHP Supported Environments](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/php-agent/php-supported-environments)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.