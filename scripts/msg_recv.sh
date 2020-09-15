#!/bin/bash

# set -x

KAFKA_HOST=${KAFKA_HOST:-kafka}
TOPIC_NAME=${1:-test}

echo "Receving msg from topic ${TOPIC_NAME} by connecting to ${KAFKA_HOST}"
bin/kafka-console-consumer.sh --bootstrap-server ${KAFKA_HOST}:9092 --topic ${TOPIC_NAME} --from-beginning

# kafka-run-class.sh kafka.tools.​GetOffsetShell --broker-list ${KAFKA_HOST}:9092 --topic test123 --time -1 --offsets 1