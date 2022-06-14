#!/bin/sh
set -e

webdis_config="/etc/webdis.json"

eexit() {
  echo >&2 'quitting..'
  killall redis-server
  killall webdis
  exit
}

# I don't think it does what I think it does..
trap eexit SIGINT SIGQUIT SIGKILL SIGTERM SIGHUP

strart_local_redis() {
  if [ -z "${REDIS_HOST}" ]; then  ## use external redis
    if [ -n "$LOCAL_REDIS" ] || [ -n "$INSTALL_REDIS" ]; then
      REDIS_HOST="127.0.0.1"
      echo >&2 "installing redis-server.."
      apk add --no-cache -q redis
      echo >&2 "starting local redis-server.."
      redis-server --daemonize yes
    fi
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
  "websockets": ${WEBSOCKETS:-false},

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

  "verbosity": ${VERBOSITY:-8},
  "logfile": "${LOGFILE:-/dev/stdout}"
}
EOF
}

if [ $# -eq 0 ]; then
  strart_local_redis

  echo "writing config.." >&2
  write_config > ${webdis_config}

  echo "starting webdis.." >&2
  webdis ${webdis_config}

fi

exec "$@"
