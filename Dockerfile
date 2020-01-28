FROM azul/zulu-openjdk-alpine:11 as builder

RUN /usr/lib/jvm/zulu11-ca/bin/jlink --output /jre \
  --add-modules java.base,java.logging,java.xml,jdk.unsupported,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument

COPY ./build/libs/*.jar /shutdown-hook.jar

ARG DOCKER_ENTRYPOINT
COPY ./docker/$DOCKER_ENTRYPOINT /docker-entrypoint.sh

RUN chmod u+x /shutdown-hook.jar /docker-entrypoint.sh


FROM alpine:3.10

COPY --from=builder /jre /jre/
COPY --from=builder /shutdown-hook.jar /shutdown-hook.jar
COPY --from=builder /docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
