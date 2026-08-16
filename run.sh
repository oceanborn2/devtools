#!/bin/bash

RUNLOC=1
#CLEAN=0

source ./.env/config.sh

if [[ ! $RUNLOC ]];
then
  $DOCKER pull "${REG}/${USR}/${IMAGE}:latest"
else
  REG=localhost
fi

#if [[ $CLEAN -eq 0 ]]; then
#  {DOCKER} container rm ${IMAGE} --force --volumes
#fi

CMD="${DOCKER} run --rm -it --name ${IMAGE} \
  --hostname ${IMAGE} \
  --volume .:/src \
  ${REG}/${USR}/${IMAGE}:latest" #  -u$(id -u):$(id -g)

echo "running : ${CMD}"

eval "$CMD"
