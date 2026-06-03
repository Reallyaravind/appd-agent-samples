# AppDynamics Node.js Agent Dual Signal Mode

## Overview
- The Node.js Combined Agent supports deploying the Splunk OpenTelemetry (OTel) Agent with the AppDynamics Agent. The agent works in Dual-signal mode and:
  - Uses AppD specific instrumentation to collect APM data for an AppD controller.
  - Uses OTel specific instrumentation to generate OTel signals and sends them to a collector.

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- Install and run Cisco AppDynamics Distribution for OpenTelemetry Collector from https://accounts.appdynamics.com/downloads
- Install the latest version of the Appdynamics nodejs agent
- Install Node.js 

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **package.json** - Installs Express, AppDynamics Node.js agent, and Splunk OTel instrumentation dependencies
2. **index.js** - Main Express application that initializes the AppDynamics agent in dual-signal mode and defines endpoints for monitoring
3. **otel-config.yaml** - OpenTelemetry Collector configuration file with receiver, processor, and exporter settings for AppDynamics

**Quick Start Guide:**

- **Install Node.js Dependencies** - Run `npm install` in the project directory

- **Configure AppDynamics Settings** - Update `index.js` with your controller hostname, port, account name, access key & other details

- **Configure OTel Collector** - Replace `<VALUE>` placeholders in `otel-config.yaml` with your collector endpoint and API key

- **Start the OTel Collector** - Execute `./appdotelcol_* --config otel-config.yaml` to launch the collector

- **Verify Collector Status** - Check if the collector is running by viewing logs or using `ps -aef | grep appdotelcol`

- **Enable Debug Logging** - Set `debug: true` in the `openTelemetry` section of `index.js` and configure the log output directory in the `logging` section

- **View Agent Logs** - Check logs in `/tmp/appd/` directory (or different configured in `index.js`)

- **Start the Application** - Run `node index.js` in the terminal

- **Test Endpoints** - ping `http://localhost:3000/` or `http://localhost:3000/hello` in your browser to generate traces

- **Verify in Controller** - Log into your AppDynamics Controller and confirm that the application appears with both AppDynamics and OTel instrumentation enabled

## Official Documentation

- [Splunk Appd OTEL](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/splunk-appdynamics-for-opentelemetry/configure-the-opentelemetry-collector/cisco-appdynamics-distribution-for-opentelemetry-collector)
- [Instrument Application](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/splunk-appdynamics-for-opentelemetry/instrument-applications-with-splunk-appdynamics-for-opentelemetry/enable-opentelemetry-in-the-node.js-agent)
- [Dual Signal Mode](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.4.0/splunk-appdynamics-for-opentelemetry/instrument-applications-with-splunk-appdynamics-for-opentelemetry/enable-opentelemetry-in-the-node.js-agent/dual-signal-mode-for-node.js-combined-agent)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.
