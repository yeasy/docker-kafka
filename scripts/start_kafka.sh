#!/bin/bash
set -euo pipefail

CFG_FILE="${KAFKA_CFG_FILE:-config/kraft/server.properties}"
DATA_DIR="${KAFKA_DATA_DIR:-/tmp/kraft-combined-logs}"
NODE_ID="${KAFKA_NODE_ID:-1}"
LISTENERS="${KAFKA_LISTENERS:-PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093}"
ADVERTISED_LISTENERS="${KAFKA_ADVERTISED_LISTENERS:-PLAINTEXT://localhost:9092}"
CONTROLLER_QUORUM_VOTERS="${KAFKA_CONTROLLER_QUORUM_VOTERS:-${NODE_ID}@localhost:9093}"
CLUSTER_ID="${KAFKA_CLUSTER_ID:-}"

upsert_prop() {
  local key="$1"
  local val="$2"
  if grep -qE "^${key}=" "${CFG_FILE}"; then
    sed -i "s#^${key}=.*#${key}=${val}#g" "${CFG_FILE}"
  else
    echo "${key}=${val}" >> "${CFG_FILE}"
  fi
}

mkdir -p "${DATA_DIR}"
upsert_prop "process.roles" "broker,controller"
upsert_prop "node.id" "${NODE_ID}"
upsert_prop "listeners" "${LISTENERS}"
upsert_prop "advertised.listeners" "${ADVERTISED_LISTENERS}"
upsert_prop "listener.security.protocol.map" "CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT"
upsert_prop "inter.broker.listener.name" "PLAINTEXT"
upsert_prop "controller.listener.names" "CONTROLLER"
upsert_prop "controller.quorum.voters" "${CONTROLLER_QUORUM_VOTERS}"
upsert_prop "log.dirs" "${DATA_DIR}"
upsert_prop "offsets.topic.replication.factor" "1"
upsert_prop "transaction.state.log.replication.factor" "1"
upsert_prop "transaction.state.log.min.isr" "1"
upsert_prop "log.retention.hours" "-1"

if [ ! -f "${DATA_DIR}/meta.properties" ]; then
  if [ -z "${CLUSTER_ID}" ]; then
    CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"
  fi
  bin/kafka-storage.sh format --ignore-formatted -t "${CLUSTER_ID}" -c "${CFG_FILE}"
fi

exec bin/kafka-server-start.sh "${CFG_FILE}"
