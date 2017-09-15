#!/bin/bash

set -x

echo "Update configurations"
sed -i "s/zookeeper.connect=localhost:2181/zookeeper.connect=zookeeper:2181/" config/server.properties

echo "Start a kafka server from `pwd`"
bin/kafka-server-start.sh config/server.properties
