#!/bin/sh
set -e

# --- workaround: disable opcache if it breaks Apache start ---
OPCACHE_INI="/usr/local/etc/php/conf.d/docker-php-ext-opcache.ini"
if [ -f "$OPCACHE_INI" ]; then
  echo "[startup] disabling opcache (workaround): $OPCACHE_INI"
  mv "$OPCACHE_INI" "${OPCACHE_INI}.disabled" || true
fi

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

${PHP_AGENT_HOME}/install.sh ${SSL_PARAM} ${NODE_REUSE} ${PHP_INI_LOCATION} \
-a=${APPDYNAMICS_AGENT_ACCOUNT_NAME}@${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY} \
--auto-launch-proxy=${APPDYNAMICS_AGENT_PROXY_AUTO_LAUNCH} \
${APPDYNAMICS_CONTROLLER_HOST_NAME} \
${APPDYNAMICS_CONTROLLER_PORT} \
${APPDYNAMICS_AGENT_APPLICATION_NAME} \
${APPDYNAMICS_AGENT_TIER_NAME} \
${APPDYNAMICS_AGENT_NODE_NAME}

# -------------------------
# Start the application (PID 1)
# -------------------------
exec ${APP_ENTRY_POINT}
