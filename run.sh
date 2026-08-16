#!/bin/bash

source ./.env/config.sh

$DOCKER pull ${REG}/${USR}/${IMAGE}:latest

${DOCKER} container rm ${IMAGE} --force --volumes

CMD="${DOCKER} run --name ${IMAGE} --hostname ${IMAGE} -it -u$(id -u):$(id -g) -v .:/src ${REG}/${USR}/${IMAGE}:latest"

eval $CMD
