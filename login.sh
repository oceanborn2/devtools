#!/bin/bash

source ./.env/config.sh
echo login using the CLI personal access token
echo $PAT | ${DOCKER} login -u${USR} ${REG} --password-stdin --authfile ~/.config/containers/auth.json

export DOCKER
export IMAGE
export REG
export USR
#export PAT
