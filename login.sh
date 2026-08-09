#!/bin/bash

DOCKER=podman

# echo login using the CLI personal access token
${DOCKER} login -uoceanborn -p<pat> docker.io
