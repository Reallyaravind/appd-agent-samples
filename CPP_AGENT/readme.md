# AppDynamics C/C++ SDK Agent Instrumentation

## Overview
- Demonstrates how to instrument a native C++ application using the **AppDynamics C/C++ SDK** to report Business Transactions (BTs) to the AppDynamics Controller.
- Spawns 10 concurrent worker threads that continuously generate load against two BTs: `error_bt` (with periodic simulated errors) and `clean_bt` (100% error-free) — useful for validating BT detection, error reporting, and dashboards.
- Handles `SIGINT` (Ctrl+C) to gracefully stop all worker threads and flush metrics via `appd_sdk_term()` before exiting.

> **Note:** This repository is intended for reference purposes. Agent configurations and requirements may evolve with new releases. Always verify steps against the [Official AppDynamics Documentation](https://help.splunk.com/en/appdynamics-saas) before proceeding.

## Prerequisites

- AppDynamics-compatible C/C++ SDK package downloaded from the [AppDynamics Download Portal](https://accounts.appdynamics.com/downloads)

## Installation Method / Code Explanation

**Simple overview of the code:**

1. **`main.cpp`** — Sample C++ application that:
   - Initializes the AppDynamics SDK via `appd_config_init()` and `appd_sdk_init()` using the configured controller credentials.
   - Spawns `NUM_THREADS = 10` worker threads (`generate_bt_load_infinite`) that run an infinite loop until interrupted.
   - In each loop iteration, starts and ends two Business Transactions:
     - **`error_bt`** — wraps a mock CPU workload and calls `appd_bt_add_error()` every 20 iterations to simulate a failure.
     - **`clean_bt`** — wraps a mock CPU workload with no errors reported.
   - Registers a `SIGINT` signal handler so Ctrl+C flips the `keep_running` flag, joins all threads, and calls `appd_sdk_term()` to flush metrics cleanly.

**Quick Start Guide:**

- **Download and Extract the SDK** — Place the SDK under `/opt`:
  ```sh
  sudo tar xvzf appdynamics-sdk-native-64bit-linux-VERSION.tar.gz -C /opt
  ```

- **Export the Library Path** — Make the SDK shared library discoverable at runtime:
  ```sh
  export LD_LIBRARY_PATH=/opt/appdynamics-cpp-sdk/lib:$LD_LIBRARY_PATH
  ```

- **Configure AppDynamics Credentials** — Edit **main.cpp** and replace all `<Value>` placeholders for appdynamics controller values.

- **Compile the Application** — Build the binary linking against the AppDynamics SDK:
  ```sh
    g++ -std=c++11 main.cpp -o main -I/opt/appdynamics-cpp-sdk/include -L/opt/appdynamics-cpp-sdk/lib -lappdynamics -pthread

  ```

- **Set `ulimit` Appropriately** — Ensure the open file / process limits are sufficient for the SDK proxy and worker threads

- **Run the Application** — Start the application:
  ```sh
  ./main
  ```
  The application runs continuously until you press **Ctrl+C**, at which point it will gracefully stop all threads and flush metrics.

- **Enable Debug Logging** — The SDK writes logs under `/tmp/appd/`. To increase verbosity, set the log level to the desired value by editing the main.cpp file.

- **Verify Agent is Running** —  Tail the logs to verify connectivity/see issues to the Controller:
  ```sh
  tail -f /tmp/appd/*.log
  ```

- **View Metrics in the Controller** — Log into your AppDynamics Controller, navigate to your configured application, and verify that the `error_bt` and `clean_bt` Business Transactions appear under the configured tier/node with the expected error rates.

## Official Documentation

- [Install the C/C++ SDK](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.5.0/install-app-server-agents/cc-sdk/use-the-cc-sdk)
- [C/C++ SDK API Reference](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.5.0/install-app-server-agents/cc-sdk/ccpp-sdk-reference/basic-types)
- [C/C++ Supported Environments](https://help.splunk.com/en/appdynamics-saas/application-performance-monitoring/26.5.0/install-app-server-agents/cc-sdk/cc-sdk-supported-environments)

## Support

If you encounter any issues with AppDynamics product, please contact Cisco AppDynamics Support by opening a TAC (Technical Assistance Center) ticket. Our engineers will assist you with troubleshooting and resolution.