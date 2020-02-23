#!/bin/bash
CHECK_PATH="auth"
if [ -n "${KEYCLOAK_PATH_PREFIX}" ]; then
    CHECK_PATH="${KEYCLOAK_PATH_PREFIX}/auth"
fi
curl -k --fail "http://localhost:8080/${CHECK_PATH}/" || exit 1