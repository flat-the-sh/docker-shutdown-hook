#!/bin/sh
set -e

if [ -z "${1##*'exec'*}" ]; then
  exec /jre/bin/java -jar shutdown-hook.jar
else
  /jre/bin/java -jar shutdown-hook.jar
fi
