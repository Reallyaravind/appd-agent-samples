# AppDynamics PHP Agent - Auto Proxy

## Overview
- Demonstrates how to instrument a PHP application running on Apache with the AppDynamics PHP Agent using **auto proxy** mode.
- The agent automatically launches the Java proxy that communicates with the AppDynamics Controller and detects business transactions for PHP endpoints.
- Packaged with **Docker Compose** so the PHP/Apache application and the AppDynamics agent run together in a single container.

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Docker installed on your machine
- AppDynamics-compatible PHP agent package downloaded from the [AppDynamics Download Portal](https://accounts.appdynamics.com/downloads) and extracted into this folder as `appdynamics-php-agent-linux_x64/`

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **app/Dockerfile** - Builds the PHP + Apache application image used to serve the sample app.
2. **app/index.php** - Simple PHP application with endpoints used to generate business transactions.
3. **run-with-appd-php-agent.sh** - Startup script that:
   - Disables PHP `opcache` (workaround to avoid Apache start issues with the agent).
   - Builds parameters for the agent `install.sh` based on environment variables (SSL, node reuse, php.ini location).
   - Runs `install.sh` to install/configure the PHP agent with auto-launch proxy enabled.
   - Execs `apache2-foreground` (from `APP_ENTRY_POINT`) as PID 1.
4. **docker-compose.yaml** - Defines the `web` service, mounts the agent and startup script into the container, exposes port `8080`, and passes all AppDynamics configuration via environment variables.

**Quick Start Guide:**

- **Download and Extract Agent** - Place the extracted PHP agent into `./appdynamics-php-agent-linux_x64/` (matches the volume mount in `docker-compose.yaml`)

- **Configure AppDynamics Credentials** - Update the `<VALUE>` placeholders in `docker-compose.yaml` with your controller / Application details.

- **Start the Application** - Run:
  ```bash
  docker compose up --build
  ```

- **Access the Application** - Open `http://localhost:8080/` in your browser to generate traffic.

- **Verify Agent is Running** - Check the container logs and confirm the proxy/agent started:
  ```bash
  docker compose logs -f web
  docker compose exec web ps -aef | grep java
  ```
  Then log into your AppDynamics Controller and confirm the application/tier/node appears under Applications with detected business transactions.

- **Enable Debug Logging** - Enable trace-level logging and collect logs for both the application (agent) and the proxy.

  For the Agent:
   1. Go to `<php_agent_root>/php/conf`
   2. Edit `appdynamics_agent_log4cxx.xml`
   3. Change the logging level value from `info` to `trace`

  For the Proxy:
   1. Go to `<php_agent_root>/proxy/conf/logging`
   2. Edit `log4j.xml`
   3. Change the logging level from `info` to `trace`

  Then restart the container and apply load for 5–10 minutes:

   ```bash
   docker compose restart web
   ```

- **View Agent Logs** - Logs are available inside the container at:
  ```
  /opt/appdynamics/php-agent/logs/
  ```
  Tail them with:
  ```bash
  docker compose exec web tail -f /opt/appdynamics/php-agent/logs/agent.log
  ```

## Official Documentation

- [Install the PHP Agent](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/php-agent/install-the-php-agent)
- [PHP Agent Configuration Properties](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/php-agent/php-agent-configuration-settings)
- [PHP Supported Environments](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/install-app-server-agents/php-agent/php-supported-environments)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.