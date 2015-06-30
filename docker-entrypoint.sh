#!/bin/sh
set -e

if [ $# -eq 0 ]; then
  echo "starting webdis.." >&2
  set -- webdis /etc/webdis.json
fi

exec "$@"
