#!/bin/bash

source .env/config.sh
source login.sh

$DOCKER tag $IMAGE:latest $REG/${USR}/${IMAGE}:latest

CMD="$DOCKER push ${REG}/${USR}/${IMAGE}:latest"
echo "Executing: $CMD"
eval $CMD
