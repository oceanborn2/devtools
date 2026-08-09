#!/bin/bash

DOCKER=podman

# cleanup : optional - can be commented out
${DOCKER} container rm devtools --force --volumes

# obtain an interactive container
${DOCKER} run  --name devtools --hostname devtools -it -u $(id -u):$(id -g) -v .:/src



