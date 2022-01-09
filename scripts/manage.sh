#!/bin/bash

CONFLUENT_DIR=${HOME}/confluent
if [ "$1" == "start" ]; then
	echo "Starting Confluent Stack..."

	echo "Starting zookeeper server..."
	${CONFLUENT_DIR}/bin/zookeeper-server-start -daemon ${CONFLUENT_DIR}/etc/kafka/zookeeper.properties
	sleep 10

	echo "Starting kafka server..."
	${CONFLUENT_DIR}/bin/kafka-server-start -daemon ${CONFLUENT_DIR}/etc/kafka/server.properties
	sleep 10

	echo "Starting schema registry..."
	${CONFLUENT_DIR}/bin/schema-registry-start -daemon ${CONFLUENT_DIR}/etc/schema-registry/schema-registry.properties
	sleep 10
	
	echo "Startup Completed"

elif [ "$1" == "stop" ]; then
	echo "Shutting down Confluent Stack..."

	echo "Shutting down zookeeper server..."
	${CONFLUENT_DIR}/bin/zookeeper-server-stop -daemon ${CONFLUENT_DIR}/etc/kafka/zookeeper.properties
	sleep 5

	echo "Shutting down kafka server..."
	${CONFLUENT_DIR}/bin/kafka-server-stop -daemon ${CONFLUENT_DIR}/etc/kafka/server.properties
	sleep 5

	echo "Shutting down schema registry..."
	${CONFLUENT_DIR}/bin/schema-registry-stop -daemon ${CONFLUENT_DIR}/etc/schema-registry/schema-registry.properties
	sleep 5

elif [ "$1" == "create-topics" ]; then
	echo "Creating topics..."
	${CONFLUENT_DIR}/bin/kafka-topics --create --partitions 1 --replication-factor 1 --config retention.ms=10800000 --topic OrderReceived --bootstrap-server localhost:9092
 
        ${CONFLUENT_DIR}/bin/kafka-topics --create --partitions 1 --replication-factor 1 --config retention.ms=10800000 --topic OrderConfirmed --bootstrap-server localhost:9092
 
        ${CONFLUENT_DIR}/bin/kafka-topics --create --partitions 1 --replication-factor 1 --config retention.ms=10800000 --topic OrderPickedAndPacked --bootstrap-server localhost:9092
 
        ${CONFLUENT_DIR}/bin/kafka-topics --create --partitions 1 --replication-factor 1 --config retention.ms=10800000 --topic Notification --bootstrap-server localhost:9092
 
        ${CONFLUENT_DIR}/bin/kafka-topics --create --partitions 1 --replication-factor 1 --config retention.ms=10800000 --topic DeadLetterQueue --bootstrap-server localhost:9092

else
	echo "Please enter a valid operation: [start, stop, create-topics]"
fi

