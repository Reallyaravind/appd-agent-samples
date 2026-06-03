# AppDynamics Python OpenTelemetry Instrumentation

## Overview

- A sample Python Flask application instrumented with **OpenTelemetry** auto-instrumentation to send traces to AppDynamics via the OpenTelemetry Collector.
- Uses the **OTel Collector** as a forwarding agent that enriches spans with AppDynamics-specific resource attributes and exports them over OTLP/HTTP to the AppDynamics ingestion endpoint.
- Packaged with **Docker Compose** so that both the application and collector run together in isolated containers.

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Docker  installed on your machine.

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **`app.py`** – A minimal Flask application exposing a `/hello` endpoint on port `8080`, used to generate sample HTTP traffic and spans.
2. **`dockerfile`** – Builds the Python application image, installs `opentelemetry-distro`, `opentelemetry-exporter-otlp`, Flask, and runs `opentelemetry-bootstrap` to auto-install relevant instrumentation libraries.
3. **`otel-config.yaml`** – OpenTelemetry Collector configuration: defines OTLP receivers (gRPC/HTTP), a `resource` processor that injects AppDynamics controller metadata, a `batch` processor, and an `otlphttp` exporter pointing at the AppDynamics endpoint.
4. **`docker-compose.yaml`** – Orchestrates two services: the `otelcol-collector` (using the official `otel/opentelemetry-collector` image) and the `app` service which runs the Flask app under `opentelemetry-instrument`.

**Quick Start Guide:**

- Update `otel-config.yaml` and replace all `<VALUE>` placeholders with your AppDynamics controller & application details.
- Build and start the stack:
  ```bash
  docker compose up --build
  ```
- Generate sample traces by hitting the application endpoint:
  ```bash
  curl http://localhost:8080/hello
  ```

- View application and collector logs:
  ```bash
  docker logs -f app
  docker logs -f otelcol-collector
  ```

- **Verify the agent/collector is running:**
  - Check container status:
    ```bash
    docker ps
    ```
  - Confirm collector is listening on OTLP ports `4317` (gRPC) and `4318` (HTTP):
    ```bash
    docker logs otelcol-collector
    ```
  - Confirm spans are being exported by inspecting collector logs for successful exporter activity or by viewing the trace in the AppDynamics Controller UI under the configured service name.

## Official Documentation

- [Splunk AppDynamics for OpenTelemetry](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/splunk-appdynamics-for-opentelemetry)
- [Instrument Python Applications with OpenTelemetry](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/splunk-appdynamics-for-opentelemetry/support-for-appdynamics-for-opentelemetry/verified-otlp-open-source-versions)
- [OpenTelemetry Collector Configuration](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/splunk-appdynamics-for-opentelemetry/configure-the-opentelemetry-collector)

## Support
If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.