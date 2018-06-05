#!/bin/bash

# WARNING: This file is deployed from template. Raise a pull request against image-template to change.

echo -e "Host *\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
chmod 600 ~/.ssh/id_rsa && eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa
aws ssm get-parameters --names "dockerhub_rw_key" --region eu-west-1 --with-decryption | jq -r ".Parameters[0].Value" > /home/travis/.docker/config.json

echo "Building docker image..."
make -f ${TRAVIS_BUILD_DIR}/Makefile pre_build
docker build --build-arg GIT_TAG_REF=$1 -t "pearsontechnology/image-$MODULE" .
docker tag pearsontechnology/image-$MODULE:latest pearsontechnology/image-$MODULE:$1
docker push pearsontechnology/image-$MODULE
docker push pearsontechnology/image-$MODULE:$1
