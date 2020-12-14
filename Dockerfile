FROM adoptopenjdk/openjdk15:alpine-slim

# https://github.com/prometheus/jmx_exporter/releases
ARG VERSION=0.14.0

ENV LANG=C.UTF-8 \
    JAVA_HOME=/opt/java/openjdk \
    PATH=${PATH}:/opt/java/openjdk/bin \
    LANG=C.UTF-8 

RUN apk add --no-cache ca-certificates bash curl

RUN sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/conf/security/java.security

RUN curl https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/${VERSION}/jmx_prometheus_httpserver-${VERSION}-jar-with-dependencies.jar -o jmx_prometheus_httpserver.jar

RUN ["/bin/bash", "-c", "echo \"export LANG=C.UTF-8\" > /etc/profile.d/locale.sh"]

ENTRYPOINT ["java", "-jar", "jmx_prometheus_httpserver.jar" , "5555", "/app/config/config.yml"]
