#!/bin/bash

# set -x

KAFKA_HOST=${KAFKA_HOST:-kafka}
TOPIC_NAME=${1:-test}

echo "Send msg to topic ${TOPIC_NAME} by connecting to ${KAFKA_HOST}"
bin/kafka-console-producer.sh --broker-list ${KAFKA_HOST}:9092 --topic ${TOPIC_NAME}
