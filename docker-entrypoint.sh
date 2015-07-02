#!/bin/sh
set -e

webdis_config="/etc/webdis.json"

eexit() {
  echo 'quitting..' >&2
  killall redis-server
  killall webdis
  exit
}

# I don't think it does what I think it does.. 
trap eexit SIGINT SIGQUIT SIGKILL SIGTERM SIGHUP

tutum_compat() {
  if [ -n "$REDIS_ENV_TUTUM_IP_ADDRESS" ]; then
    echo "${REDIS_ENV_TUTUM_IP_ADDRESS%/*}  redis" >> /etc/hosts
  elif [ -n "$LOCAL_REDIS" ] || [ -n "$INSTALL_REDIS" ]; then
    echo "127.0.0.1  redis" >> /etc/hosts
  fi
}

install_redis() {
  if [ -n "$LOCAL_REDIS" ] || [ -n "$INSTALL_REDIS" ]; then
    REDIS_HOST="127.0.0.1"
    echo "installing redis-server.." >&2
    apk update && apk add redis
    echo "starting redis-server.." >&2
    redis-server >/redis-server.log 2>&1 &
  fi
}

write_config() {
ACL_DISABLED=${ACL_DISABLED:-\"DEBUG\", \"FLUSHDB\", \"FLUSHALL\"}
ACL_HTTP_BASIC_AUTH_ENABLED=${ACL_HTTP_BASIC_AUTH_ENABLED:-\"DEBUG\"}
[ -n "$REDIS_PORT" ] && REDIS_PORT=${REDIS_PORT##*:}
cat - <<EOF
{
  "redis_host": "${REDIS_HOST:-redis}",

  "redis_port": ${REDIS_PORT:-6379},
  "redis_auth": ${REDIS_AUTH:-null},

  "http_host": "${HTTP_HOST:-0.0.0.0}",
  "http_port": ${HTTP_PORT:-7379},

  "threads": ${THREADS:-5},
  "pool_size": ${POOL_SIZE:-10},

  "daemonize": false,
  "websockets": ${WEBSOCKETS:-true},

  "database": ${DATABASE:-0},

  "acl": [
    {
      "disabled": [${ACL_DISABLED}]
    },

    {
      "http_basic_auth": "${ACL_HTTP_BASIC_AUTH:-user:password}",
      "enabled":  [${ACL_HTTP_BASIC_AUTH_ENABLED}]
    }
  ],

  "verbosity": ${VERBOSITY:-99},
  "logfile": "${LOGFILE:-/webdis.log}"
}
EOF
}

if [ $# -eq 0 ]; then
  tutum_compat || true
  install_redis

  echo "writing config.." >&2
  write_config > ${webdis_config}

  echo "taking a 3 second nap.." >&2
  for i in 3 2 1; do echo -n "$i " >&2; sleep 1; done
  echo

  tail -F ${LOGFILE:-/webdis.log} &
  echo "starting webdis.." >&2
  webdis ${webdis_config}

fi

exec "$@"
