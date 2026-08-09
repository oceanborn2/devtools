#!/bin/bash

DOCKER=podman

# cleanup
#${DOCKER} login

#${DOCKER} container rm devtools --force --volumes

${DOCKER} run --name devtools --hostname devtools -it -u $(id -u):$(id -g) -v .:/src devtools


