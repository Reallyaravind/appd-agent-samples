require("appdynamics").profile({
  reuseNode: true,
  reuseNodePrefix: process.env.APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX,
  proxyHost: process.env.APPDYNAMICS_PROXY_HOST_NAME,
  proxyPort: process.env.APPDYNAMICS_PROXY_PORT,
  processSnapshotCountResetPeriodSeconds: 60 ,
  maxProcessSnapshotsPerPeriod: 2 ,
  autoSnapshotDurationSeconds: 10
});