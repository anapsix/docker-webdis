#!/bin/sh
set -e

tutum_compat() {
  if [ -n "$REDIS_1_ENV_TUTUM_IP_ADDRESS" ]; then
    echo "${REDIS_1_ENV_TUTUM_IP_ADDRESS%/*}  redis" >> /etc/hosts
  fi
}

tutum_compat || true

if [ $# -eq 0 ]; then
  webdis_config="/etc/webdis.json"
  echo "starting webdis.." >&2
  set -- webdis /etc/webdis.json
fi

exec "$@"
