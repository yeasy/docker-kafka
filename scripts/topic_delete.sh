#!/bin/bash

#set -x

ZK_HOST=${ZK_HOST:-zookeeper1}
TOPIC_NAME=${1:-test}

echo "Delete topic ${TOPIC_NAME} by connecting to ${ZK_HOST}"

/opt/kafka/bin/kafka-topics.sh --delete --zookeeper ${ZK_HOST}:2181 --topic ${TOPIC_NAME}
