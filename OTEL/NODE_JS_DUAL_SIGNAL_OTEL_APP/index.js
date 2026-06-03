const appdynamics = require("appdynamics");

appdynamics.profile({
    controllerHostName: '<controller host name>',
    controllerPort: <controller_port_number>,
    controllerSslEnabled: false,  // Set to true if controllerPort is SSL
    accountName: '<AppDynamics_account_name>',
    accountAccessKey: '<AppDynamics_account_key>', //required
    applicationName: 'your_app_name',
    noNodeNameSuffix: true,
    logging: {
        'logfiles': [
        {
            'root_directory': "/tmp/appd",
            'filename': 'VALUE',
            'level': 'FATAL | ERROR | WARN | INFO | DEBUG | TRACE',
            'max_size': VALUE,
            'max_files': VALUE,
            //'output Type': 'console' // Set this parameter if you want to log to STDOUT/STDERR. Omit this parameter if you want to log to a file.
        }
      ]
    },
    agent_deployment_mode: `otel | dual`, // Set to 'otel' for OpenTelemetry, 'dual' for both
    openTelemetry: {
        enabled: true,
        debug: true,
        collector: {
        url: "http://localhost:4318/v1/traces" //OTEL COLLECTOR SAMPLE URL
        }
    },
    tierName: 'choose_a_tier_name',
    nodeName: 'choose_a_node_name'
});

const express = require('express');


const app = express();
const PORT = 3000;

// --- ROUTES ---

app.get('/hello', (req, res) => {
  res.send('Hello World!')
})
app.get('/', (req, res) => {
  res.send('Hello World!')
})



// Start server
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});