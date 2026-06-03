require("appdynamics").profile({
  reuseNode: true,
  reuseNodePrefix: process.env.APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX,
  analytics: {
    host: process.env.APPDYNAMICS_ANALYTICS_HOST_NAME,
    port: process.env.APPDYNAMICS_ANALYTICS_PORT,
    ssl: process.env.APPDYNAMICS_ANALYTICS_SSL_ENABLED === 'true'
  },
  certificateFile: process.env.APPDYNAMICS_CERTIFICATE_FILE || undefined
});
