#!/bin/bash

# cleanup
docker login

#docker container rm devtools --force --volumes

docker run --name devtools --hostname devtools -it -u $(id -u):$(id -g) -v .:/src devtools


