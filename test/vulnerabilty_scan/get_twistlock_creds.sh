#!/bin/bash

# WARNING: This file is deployed from template. Raise a pull request against image-template to change.

if [ -z "${AWS_PROFILE}" ] || [ "${AWS_PROFILE}" == '' ]; then
    unset AWS_PROFILE #Travis
    echo "empty AWS_PROFILE has been unset to ${AWS_PROFILE}"
else
    echo "AWS_PROFILE is already set to ${AWS_PROFILE}"
fi


TWISTLOCK_CREDS_JSON=$(aws secretsmanager get-secret-value --secret-id non-prod/twistlock/travisci_creds --region=us-west-2| jq -r .SecretString)
export TWISTLOCK_USER=$(echo ${TWISTLOCK_CREDS_JSON} | jq -r .username)
export TWISTLOCK_PASS=$(echo ${TWISTLOCK_CREDS_JSON} | jq -r .password)
export TWISTLOCK_API_URL=$(echo ${TWISTLOCK_CREDS_JSON} | jq -r .api_url)

