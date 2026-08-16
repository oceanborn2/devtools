#!/bin/bash

source ./.env/config.sh # source login.sh ? needed to push or pull

export KUML_VER=0.50.0

#curl -L -o ./lib/kuml.zip https://github.com/kuml-dev/kUML/releases/download/v${KUML_VER}/kuml-runtime-${KUML_VER}-darwin-arm64.zip

# build the image
$DOCKER buildx build \
  --build-arg username=pascal \
  --build-arg kuml_ver=$KUML_VER \
  --build-arg language=en \
  --logfile make.log \
  --identity-label  -t ${USR}/${IMAGE} \
  . &

tail -f make.log

