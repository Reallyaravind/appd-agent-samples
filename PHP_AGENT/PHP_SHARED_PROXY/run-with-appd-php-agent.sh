#!/bin/bash
set -e

# -------------------------
# Wait for AppDynamics PHP Proxy (TCP comm port)
# -------------------------
HOST="${APPDYNAMICS_TCP_COMM_HOST:-appd-proxy}"
PORT="${APPDYNAMICS_TCP_COMM_PORT:-3000}"

echo "[startup] waiting for appd-proxy at ${HOST}:${PORT} ..."
i=0
until HOST="$HOST" PORT="$PORT" php -r '
$h=getenv("HOST");
$p=(int)getenv("PORT");
$s=@fsockopen($h,$p,$e,$es,1);
if(!$s){ exit(1); }
fclose($s);
'
do
  i=$((i+1))
  if [ "$i" -ge 60 ]; then
    echo "[startup] appd-proxy is not reachable after 60 tries, exiting"
    exit 1
  fi
  sleep 1
done
echo "[startup] appd-proxy is reachable"

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

chmod -R 755 "${PHP_AGENT_HOME}"
chmod 777 "${PHP_AGENT_HOME}"/logs

bash ${PHP_AGENT_HOME}/install.sh ${SSL_PARAM} ${NODE_REUSE} ${PHP_INI_LOCATION} \
-a=${APPDYNAMICS_AGENT_ACCOUNT_NAME}@${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY} \
--auto-launch-proxy=${APPDYNAMICS_AGENT_PROXY_AUTO_LAUNCH} \
--tcp-comm-host=${APPDYNAMICS_TCP_COMM_HOST} \
--tcp-comm-port=${APPDYNAMICS_TCP_COMM_PORT} \
--tcp-port-range=${APPDYNAMICS_TCP_PORT_RANGE} \
${APPDYNAMICS_CONTROLLER_HOST_NAME} \
${APPDYNAMICS_CONTROLLER_PORT} \
${APPDYNAMICS_AGENT_APPLICATION_NAME} \
${APPDYNAMICS_AGENT_TIER_NAME} \
${APPDYNAMICS_AGENT_NODE_NAME}

# -------------------------
# Start the application (PID 1)
# -------------------------
exec ${APP_ENTRY_POINT}
