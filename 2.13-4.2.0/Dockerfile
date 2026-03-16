FROM eclipse-temurin:21-jre-jammy
LABEL maintainer="yeasy@github.com"

ENV KAFKA_VERSION=4.2.0 \
    SCALA_VERSION=2.13 \
    KAFKA_HOME=/opt/kafka
ENV KAFKA_PKG=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ENV PATH=${PATH}:${KAFKA_HOME}/bin

RUN apt-get update \
    && apt-get install -y --no-install-recommends bash ca-certificates wget netcat-openbsd \
    && rm -rf /var/lib/apt/lists/* \
    && cd /opt \
    && wget -q "https://downloads.apache.org/kafka/${KAFKA_VERSION}/${KAFKA_PKG}.tgz" \
    && tar xzf "${KAFKA_PKG}.tgz" \
    && mv "/opt/${KAFKA_PKG}" "${KAFKA_HOME}" \
    && rm -f "${KAFKA_PKG}.tgz"

COPY scripts/* /tmp/

WORKDIR ${KAFKA_HOME}

EXPOSE 9092
EXPOSE 9093

HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD ["/tmp/healthcheck.sh"]

CMD ["bash", "/tmp/start_kafka.sh"]
