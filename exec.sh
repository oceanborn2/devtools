#!/bin/bash

# cleanup : optional - can be commented out
docker container rm devtools --force --volumes

# obtain an interactive container
docker run  --name devtools --hostname devtools -it -u $(id -u):$(id -g) -v .:/src



