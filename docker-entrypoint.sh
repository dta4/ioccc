#!/bin/bash
set -e

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
#  (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#   "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
function file_env() {
  local var="$1"
  local fileVar="${var}_FILE"
  local def="${2:-}"
  if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
    echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
    exit 1
  fi
  local val="$def"
  if [ "${!var:-}" ]; then
    val="${!var}"
  elif [ "${!fileVar:-}" ]; then
    val="$(< "${!fileVar}")"
  fi
  export "$var"="$val"
  unset "$fileVar"
}

# envs=(
#   XYZ_API_TOKEN
# )
# haveConfig=
# for e in "${envs[@]}"; do
#   file_env "$e"
#   if [ -z "$haveConfig" ] && [ -n "${!e}" ]; then
#     haveConfig=1
#   fi
# done

# return true if specified directory is empty
function directory_empty() {
  [ -n "$(find "${1}"/ -prune -empty)" ]
}

echo Running: "$@"

# Avoid destroying bootstrapping by simple start/stop
if [[ ! -e /.bootstrapped ]]; then
  ### list none idempotent configuration code blocks, here...

  touch /.bootstrapped
fi

if [[ `basename ${1}` == "socat" ]]; then # prod
  exec "$@" #</dev/null #>/dev/null 2>&1
else # dev
  : # nop
  socat -d -d -lf /var/log/socat.log TCP4-LISTEN:10042,bind=0.0.0.0,fork EXEC:"/root/oregonator /root/ioccc.txt" &
fi

# fallthrough...
exec "$@"
