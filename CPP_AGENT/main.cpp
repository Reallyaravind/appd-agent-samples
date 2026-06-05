#include "appdynamics.h"
#include <iostream>
#include <vector>
#include <thread>
#include <unistd.h> // Required for usleep()
#include <csignal>  // Required to handle Ctrl+C cleanly

// Configuration Constants
const char APP_NAME[] = "<Value>";
const char TIER_NAME[] = "<Value>";
const char NODE_NAME[] = "<Value>";
const char CONTROLLER_HOST[] = "<Value>";
const int CONTROLLER_PORT = <Value>;
const char CONTROLLER_ACCOUNT[] = "<Value>";
const char CONTROLLER_ACCESS_KEY[] = "<Value>";
const int CONTROLLER_USE_SSL = <Value>;

const char LOG_DIR[] = "/tmp/appd"; // Directory where SDK log files will be saved

// Global flag to control the loop execution status safely
volatile sig_atomic_t keep_running = 1;

// Signal handler function to capture Ctrl+C cleanly
void signal_handler(int signum) {
    std::cout << "\n[!] Ctrl+C detected. Gracefully shutting down threads..." << std::endl;
    keep_running = 0;
}

// Thread worker running both BTs continuously until keep_running becomes 0
void generate_bt_load_infinite(int thread_id) {
    std::cout << "Thread " << thread_id << " started (Infinite Mode with 2 BTs)." << std::endl;
    
    unsigned long long loop_count = 0;

    while (keep_running) {
        // -----------------------------------------------------------------
        // BT 1: "process" (Generates load AND triggers periodic errors)
        // -----------------------------------------------------------------
        appd_bt_handle btHandle1 = appd_bt_begin("error_bt", NULL);
        
        // Mock CPU workload
        volatile long long sum1 = 0;
        for (int j = 1; j <= 100000; ++j) {
            sum1 += j;
        }

        // Periodically simulate errors 
        if (loop_count % 20 == 0) {
            appd_bt_add_error(btHandle1,
                            APPD_LEVEL_ERROR,
                            "Simulated continuous high-load error",
                            1); // 1 marks this transaction execution as a failure
        }

        appd_bt_end(btHandle1);


        // -----------------------------------------------------------------
        // BT 2: "clean_process" (Generates pure load, 100% Error-Free)
        // -----------------------------------------------------------------
        appd_bt_handle btHandle2 = appd_bt_begin("clean_bt", NULL);
        
        // Mock CPU workload
        volatile long long sum2 = 0;
        for (int j = 1; j <= 100000; ++j) {
            sum2 += j;
        }

        // No appd_bt_add_error here

        appd_bt_end(btHandle2);


        // Increment the cycle tracking counter
        loop_count++;

        // Short pause (15ms) to prevent pinning your system CPU cores to 100%
        usleep(15000); 
    }
    
    std::cout << "Thread " << thread_id << " stopped. Processed " 
              << loop_count << " of 'process' and " << loop_count << " of 'clean_process'." << std::endl;
}

int main() {
    // Register the signal handler for Ctrl+C (SIGINT)
    std::signal(SIGINT, signal_handler);

    // Initialize AppDynamics SDK Config
    struct appd_config* cfg = appd_config_init(); 
    appd_config_set_app_name(cfg, APP_NAME);
    appd_config_set_tier_name(cfg, TIER_NAME);
    appd_config_set_node_name(cfg, NODE_NAME);
    appd_config_set_controller_host(cfg, CONTROLLER_HOST);
    appd_config_set_controller_port(cfg, CONTROLLER_PORT);
    appd_config_set_controller_account(cfg, CONTROLLER_ACCOUNT);
    appd_config_set_controller_access_key(cfg, CONTROLLER_ACCESS_KEY);
    appd_config_set_controller_use_ssl(cfg, CONTROLLER_USE_SSL);
    appd_config_set_logging_log_dir(cfg, LOG_DIR);
    appd_config_set_logging_min_level(cfg, LOGGING_MIN_LEVEL); 
    // Options for logging -> LOGGING_MIN_LEVEL, APPD_LOG_LEVEL_TRACE, APPD_LOG_LEVEL_DEBUG , APPD_LOG_LEVEL_INFO , APPD_LOG_LEVEL_WARN, APPD_LOG_LEVEL_ERROR , APPD_LOG_LEVEL_FATAL

    int initRC = appd_sdk_init(cfg);
    if (initRC) {
        std::cerr << "Error: AppDynamics SDK init failed: " << initRC << std::endl;
        return -1;
    }

    std::cout << "SDK Initialized. Generating dual-BT load non-stop." << std::endl;
    std::cout << "--> 'process' will have ~5% error rate." << std::endl;
    std::cout << "--> 'clean_process' will have 0% error rate." << std::endl;
    std::cout << "Press Ctrl+C to exit safely and flush remaining metrics." << std::endl;

    // Spin up 10 concurrent processing threads
    const int NUM_THREADS = 10;     
    std::vector<std::thread> workers;

    for (int i = 0; i < NUM_THREADS; ++i) {
        workers.push_back(std::thread(generate_bt_load_infinite, i));
    }

    // Wait here while background threads execute infinitely
    for (auto& th : workers) {
        th.join();
    }

    // When keep_running becomes 0, execution drops here to shutdown cleanly
    std::cout << "Flushing metrics cache and terminating agent link..." << std::endl;
    appd_sdk_term();
    std::cout << "Exited cleanly. Check your AppDynamics dashboard!" << std::endl;

    return 0;
}