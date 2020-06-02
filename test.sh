#!/bin/sh
set -e


run_container() {
  name=$1

  docker run -d \
	  --name $name \
	  -v /"$(pwd)"/log/:/log/ \
	  docker-shutdown-hook $name

  docker top $name
  sleep 5s
  docker stop $name

  tail -2 ./log/context.log
}


cleanup() {
  docker rm -f -v $(docker ps -aq -f ancestor=docker-shutdown-hook)
  docker rmi -f docker-shutdown-hook
}
trap cleanup EXIT


./gradlew --quiet clean assemble

docker build --quiet -t docker-shutdown-hook .


run_container 'plain-java-entrypoint'

run_container 'exec-entrypoint'
