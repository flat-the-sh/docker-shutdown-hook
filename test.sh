#!/bin/sh
set -e

./gradlew clean assemble


docker build --build-arg DOCKER_ENTRYPOINT=docker-entrypoint.sh -t shutdown-hook .

docker run --name shutdown-hook -d -v /"$(pwd)"/log/:/log/ shutdown-hook
docker top shutdown-hook
sleep 5s
docker stop shutdown-hook
docker rm -f shutdown-hook

tail -2 ./log/context.log


docker build --build-arg DOCKER_ENTRYPOINT=docker-entrypoint-exec.sh -t shutdown-hook-exec .

docker run --name shutdown-hook-exec -d -v /"$(pwd)"/log/:/log/ shutdown-hook-exec
docker top shutdown-hook-exec
sleep 5s
docker stop shutdown-hook-exec
docker rm -f shutdown-hook-exec

tail -2 ./log/context.log
