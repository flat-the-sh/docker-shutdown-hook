FROM azul/zulu-openjdk-alpine:11 as jre-builder

RUN /usr/lib/jvm/zulu11-ca/bin/jlink --output /jre \
  --add-modules java.base,java.logging,java.xml,jdk.unsupported,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument


FROM alpine:3.10

COPY --from=jre-builder /jre /jre/

COPY ./build/libs/*.jar /shutdown-hook.jar

ARG DOCKER_ENTRYPOINT
COPY ./docker/$DOCKER_ENTRYPOINT /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
