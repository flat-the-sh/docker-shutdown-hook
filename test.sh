#!/bin/sh
set -e


default_name=shutdown-hook
exec_name=shutdown-hook-exec


run_container() { 
  entrypoint=$1
  name=$2

  docker build --quiet \
	--build-arg DOCKER_ENTRYPOINT=$entrypoint \
	-t $name \
	.

  docker run -d \
	--name $name \
	-v /"$(pwd)"/log/:/log/ \
	$name

  docker top $name
  sleep 5s
  docker stop $name

  tail -2 ./log/context.log
}


cleanup() {
  docker rm -f -v $default_name $exec_name
  docker rmi -f $default_name $exec_name
}
trap cleanup EXIT


./gradlew --quiet clean assemble


run_container docker-entrypoint.sh $default_name

run_container docker-entrypoint-exec.sh $exec_name

