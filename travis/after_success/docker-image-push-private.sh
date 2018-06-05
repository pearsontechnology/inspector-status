#!/bin/bash
# WARNING: This file is deployed from template. Raise a pull request against image-template to change.

echo -e "Host *\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
chmod 600 ~/.ssh/id_rsa && eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa

eval $(aws_role_credentials user \
     arn:aws:iam::602604727914:role/secret/repository_owner secret \
     --exec 'aws ecr get-login --no-include-email --region us-east-1' 2>/dev/null )

echo "Building docker image..."
make -f ${TRAVIS_BUILD_DIR}/Makefile pre_build
docker build --build-arg GIT_TAG_REF=$1 -t "602604727914.dkr.ecr.us-east-1.amazonaws.com/image-$MODULE" .
docker tag 602604727914.dkr.ecr.us-east-1.amazonaws.com/image-$MODULE:latest 602604727914.dkr.ecr.us-east-1.amazonaws.com/image-$MODULE:$1
docker push 602604727914.dkr.ecr.us-east-1.amazonaws.com/image-$MODULE
docker push 602604727914.dkr.ecr.us-east-1.amazonaws.com/image-$MODULE:$1
