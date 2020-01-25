FROM azul/zulu-openjdk-alpine:11-jre

COPY ./build/libs/*.jar /shutdown-hook.jar

ARG DOCKER_ENTRYPOINT
COPY ./docker/$DOCKER_ENTRYPOINT /docker-entrypoint.sh

RUN chmod u+x /shutdown-hook.jar /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
