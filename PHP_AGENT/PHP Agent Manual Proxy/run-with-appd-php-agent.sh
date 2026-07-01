#!/bin/bash
set -e


# -------------------------
# Build install.sh params
# -------------------------
SSL_PARAM=""
NODE_REUSE=""
PHP_INI_LOCATION=""

if [ "${APPDYNAMICS_CONTROLLER_SSL_ENABLED}" = "true" ]; then
    SSL_PARAM=" -s "
fi

if [ "${APPDYNAMICS_AGENT_NODE_REUSE}" = "true" ]; then
    NODE_REUSE=" -r "
fi

if [ -n "${APPDYNAMICS_PHP_INI_LOCATION}" ]; then
    PHP_INI_LOCATION=" -i=${APPDYNAMICS_PHP_INI_LOCATION} "
fi

PHP_AGENT_HOME=/opt/appdynamics/php-agent

# -------------------------
# Permissions
# -------------------------
chown -R www-data:www-data "${PHP_AGENT_HOME}" || true
chmod -R 755 "${PHP_AGENT_HOME}"
mkdir -p "${PHP_AGENT_HOME}/logs"
chmod 777 "${PHP_AGENT_HOME}/logs"

# -------------------------
# Run installer (Step 5)
# -------------------------
bash ${PHP_AGENT_HOME}/install.sh ${SSL_PARAM} ${NODE_REUSE} ${PHP_INI_LOCATION} \
-a=${APPDYNAMICS_AGENT_ACCOUNT_NAME}@${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY} \
--auto-launch-proxy=${APPDYNAMICS_AGENT_PROXY_AUTO_LAUNCH} \
${APPDYNAMICS_CONTROLLER_HOST_NAME} \
${APPDYNAMICS_CONTROLLER_PORT} \
${APPDYNAMICS_AGENT_APPLICATION_NAME} \
${APPDYNAMICS_AGENT_TIER_NAME} \
${APPDYNAMICS_AGENT_NODE_NAME}

# -------------------------
# Append missing proxy config to appdynamics_agent.ini
# -------------------------
AGENT_INI="${APPDYNAMICS_PHP_INI_LOCATION}/appdynamics_agent.ini"

echo "agent.auto_launch_proxy = 0" >> "${AGENT_INI}"
echo "agent.proxy_script = ${PHP_AGENT_HOME}/proxy/runProxy" >> "${AGENT_INI}"
echo "agent.proxy_ctrl_dir = /tmp/proxy.communication" >> "${AGENT_INI}"

# -------------------------
# Create proxy runtime dir
# -------------------------
PROXY_RUNTIME_DIR="${APPDYNAMICS_AGENT_PROXY_CTRL_DIR}/${APPDYNAMICS_AGENT_APPLICATION_NAME}/${APPDYNAMICS_AGENT_TIER_NAME}/${APPDYNAMICS_AGENT_NODE_NAME}"
mkdir -p "${PROXY_RUNTIME_DIR}"
mkdir -p /tmp/proxy.communication
mkdir -p /tmp/agentLogs
chmod -R 777 /tmp/proxy.communication /tmp/agentLogs

# -------------------------
# Manually launch the proxy, since auto-launch is disabled
# -------------------------
if [ "${APPDYNAMICS_AGENT_PROXY_AUTO_LAUNCH}" = "0" ]; then
  echo "[startup] auto-launch-proxy disabled — starting proxy manually"
  "${PHP_AGENT_HOME}/proxy/runProxy" \
    -d "${PHP_AGENT_HOME}/proxy" \
    -r "${PROXY_RUNTIME_DIR}" \
    --agent-type=PHP_APP_AGENT \
    /tmp/proxy.communication \
    /tmp/agentLogs &
fi

echo "[startup] Waiting for proxy initialization..."
sleep 5

# -------------------------
# Start the application
# -------------------------
exec ${APP_ENTRY_POINT}
