# Kafka image
# github.com/yeasy/docker-kafka

# KAFKA_HOME=/opt/kafka
# Add $KAFKA_HOME/bin to the $PATH.
# workdir is set to $KAFKA_HOME

FROM anapsix/alpine-java:8

MAINTAINER <yeasy@github.com>

ENV KAFKA_VERSION=2.4.0 \
    SCALA_VERSION=2.13

ENV KAFKA_PKG=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ENV KAFKA_HOME=/opt/kafka
ENV PATH=$PATH:${KAFKA_HOME}/bin

# kafka config is at /opt/kafka/config/server.properties
RUN wget http://www-us.apache.org/dist/kafka/${KAFKA_VERSION}/${KAFKA_PKG}.tgz \
        && tar xzf ${KAFKA_PKG}.tgz -C /opt \
        && mv /opt/${KAFKA_PKG} ${KAFKA_HOME}

ENV ZK_VERSION=3.5.6
# zk config is at /opt/zookeeper/conf/zoo.cfg
# Only for testing, as kafka already include a zookeeper
RUN wget http://www.trieuvan.com/apache/zookeeper/zookeeper-${ZK_VERSION}/apache-zookeeper-${ZK_VERSION}-bin.tar.gz \
        && tar xzf apache-zookeeper-${ZK_VERSION}-bin.tar.gz -C /opt \
        && mv /opt/apache-zookeeper-${ZK_VERSION}-bin /opt/zookeeper \
        cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg

COPY scripts/* /tmp/

WORKDIR $KAFKA_HOME

# Start a zk service for the kafka to use
#CMD ["bash", "/tmp/start_zk.sh"]

RUN mkdir -p /u01/bin/

COPY healthcheck.sh /u01/bin/

# Start a kafka service
HEALTHCHECK --interval=5m --timeout=3s CMD sh /u01/bin/healthcheck.sh

CMD ["bash", "/tmp/start_zk.sh"]
