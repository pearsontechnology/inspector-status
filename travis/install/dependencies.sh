#!/bin/bash

# WARNING: This file is deployed from template. Raise a pull request against image-template to change.
# For repo specific dependencies, please add them via the mocks.sh or an altenative file

set -e
set -x

git remote set-url origin git@github.com:pearsontechnology/${REPO_NAME}.git
wget https://packages.chef.io/files/stable/inspec/1.49.2/ubuntu/14.04/inspec_1.49.2-1_amd64.deb && sudo dpkg -i inspec_1.49.2-1_amd64.deb
wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O /home/travis/bin/jq && chmod +x /home/travis/bin/jq
pip install awscli aws-role-credentials google-compute-engine boto3 jinja2 pytest j2cli[yaml]
aws ssm get-parameters --names "github_rw_key" --region eu-west-1 --with-decryption | jq -r ".Parameters[0].Value" > ~/.ssh/id_rsa
