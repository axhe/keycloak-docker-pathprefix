#!/bin/bash
set -eou pipefail

if [ -n "${KEYCLOAK_PATH_PREFIX}" ]; then
  echo "Setting path prefix to ${KEYCLOAK_PATH_PREFIX}"
  sed -i -e "s/<web-context>auth<\/web-context>/<web-context>${KEYCLOAK_PATH_PREFIX}\/auth<\/web-context>/" $JBOSS_HOME/standalone/configuration/standalone.xml
  sed -i -e "s/<web-context>auth<\/web-context>/<web-context>${KEYCLOAK_PATH_PREFIX}\/auth<\/web-context>/" $JBOSS_HOME/standalone/configuration/standalone-ha.xml
  sed -i -e "s/name=\"\/\"/name=\"\/${KEYCLOAK_PATH_PREFIX}\/\"/" $JBOSS_HOME/standalone/configuration/standalone.xml
  sed -i -e "s/name=\"\/\"/name=\"\/${KEYCLOAK_PATH_PREFIX}\/\"/" $JBOSS_HOME/standalone/configuration/standalone-ha.xml
  sed -i -e "s/\/auth/\/${KEYCLOAK_PATH_PREFIX}\/auth/" $JBOSS_HOME/welcome-content/index.html
fi

echo "Entrypoint Parameters: $@"

exec /opt/jboss/tools/docker-entrypoint.sh "$@"