#!/bin/bash

source ./.env/config.sh

# cleanup : optional - can be commented out
${DOCKER} container rm ${IMAGE} --force --volumes

# obtain an interactive container
${DOCKER} exec ${IMAGE} -it -u $(id -u):$(id -g) -v .:/src ${USR}/${IMAGE}:latest
