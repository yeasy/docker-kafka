#!/bin/bash

#set -x

echo "Start a single-node ZooKeeper from `pwd`"
bin/zookeeper-server-start.sh config/zookeeper.properties
