#!/bin/bash

set -e

influx bucket create -n tracker_test_db -o ${DOCKER_INFLUXDB_INIT_ORG}
