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

# zk config is at /opt/zookeeper/conf/zoo.cfg
# Only for testing, as kafka already include a zookeeper
RUN wget http://www.trieuvan.com/apache/zookeeper/zookeeper-3.5.6/apache-zookeeper-3.5.6-bin.tar.gz \
        && tar xzf apache-zookeeper-3.5.6-bin.tar.gz -C /opt \
        && mv /opt/apache-zookeeper-3.5.6-bin /opt/zookeeper \
        && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg

#RUN rm -rf /opt/zookeeper/lib

#COPY zookeeper-3.5.6-old/lib /opt/zookeeper/lib
#COPY zookeeper-3.5.6-old/conf/log4j.properties /opt/zookeeper/conf/log4j.properties

COPY scripts/* /tmp/

WORKDIR $KAFKA_HOME

# Start a zk service for the kafka to use
#CMD ["bash", "/tmp/start_zk.sh"]

# Start a kafka service
CMD ["bash", "/tmp/start_kafka.sh"]
