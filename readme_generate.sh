#!/bin/bash

# WARNING: This file is deployed from template. Raise a pull request against image-template to change.

set -e

if [ ! -f README_TEMPLATE.md.j2 ]; then
    echo "README_TEMPLATE.md.j2 not found. This file must be present. Exiting script."
    exit 1
fi

if [ ! -f README_APP.md ]; then
    echo -e "README_APP.md not found. Your readme will not contain any application specific info. It will be overwritten with the same readme.md from the image-template repo. \nTo avoid this please create the file README_APP.md in the root directory and populate it with the info specific to your application."
fi


export REPO_NAME=${1}

unset README_APP_CONTENT
unset README_APP_DEPENDENCIES

export README_APP_CONTENT=$(cat README_APP.md)
export README_APP_DEPENDENCIES=$(cat README_APP_DEPENDENCIES.md 2>/dev/null)

export BUILD_STATUS="[![Build Status](https://travis-ci.com/pearsontechnology/${REPO_NAME}.svg?token=AGpoZrvw2gvbstQQZ3Uc&branch=master)](https://travis-ci.com/pearsontechnology/${REPO_NAME}) "

j2 README_TEMPLATE.md.j2 > README.md

if [ $? == 0 ]; then
    echo "README.md successfully updated"
    echo '<!-- DO NOT EDIT THIS FILE DIRECTLY!!! THIS FILE IS GENERATED SO CHANGES MADE HERE WILL BE OVERWRITTEN. SEE https://github.com/pearsontechnology/image-template#updating-the-readmemd FOR INFO HOW TO UPDATE THIS FILE -->  ' | cat - README.md > README.tmp && mv README.tmp README.md
else
    echo "README.md update FAILED!"
    exit $?
fi



