#!/bin/bash

#set -x

echo "Update configurations"
echo "Setting zk addr"
sed -i "s/zookeeper.connect=localhost:2181/zookeeper.connect=${ZK_URL}/" config/server.properties
echo "Disable log retention"
sed -i "s/log.retention.hours=168/log.retention.hours=-1/" config/server.properties
echo "Set broker id from env"
[ $KAFKA_BROKER_ID ] && sed -i "s/broker.id=0/broker.id=${KAFKA_BROKER_ID}/" config/server.properties

grep -v "#" config/server.properties

echo "Start a kafka server from `pwd`"
bin/kafka-server-start.sh config/server.properties
