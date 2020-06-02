FROM azul/zulu-openjdk-alpine:11 as builder

RUN /usr/lib/jvm/zulu11-ca/bin/jlink --output /build/jre \
  --add-modules java.base,java.logging,java.xml,jdk.unsupported,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument

COPY ./build/libs/*.jar /build/shutdown-hook.jar

COPY ./docker-entrypoint.sh /build/docker-entrypoint.sh

RUN chmod u+x /build/docker-entrypoint.sh


FROM alpine:3.10

COPY --from=builder /build/ /

ENTRYPOINT ["/docker-entrypoint.sh"]
