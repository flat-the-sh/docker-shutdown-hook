FROM azul/zulu-openjdk-alpine:11-jre

COPY ./build/libs/*.jar /shutdown-hook.jar

ARG docker_entrypoint
COPY ./docker/$docker_entrypoint /docker-entrypoint.sh

RUN chmod u+x /shutdown-hook.jar /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
