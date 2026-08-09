#!/bin/bash

DOCKER=podman

# build the container
$DOCKER buildx build . -t oceanborn/devtools


$DOCKER push oceanborn/devtools
#$DOCKER push oceanborn/devtools docker.io

