#!/bin/bash

# WARNING: This file is deployed from template. Raise a pull request against image-template to change.

export tag=$(${TRAVIS_BUILD_DIR}/travis/after_success/git-tag-version.sh)

echo "NEW GIT TAG: ${tag}"
mkdir ~/.docker

if [[ "${tag}" != *"Not versioning template update"* ]]; then

	if [ -e "${TRAVIS_BUILD_DIR}/docker-public-repo-enabled" ] ; then
	    echo "ABOUT TO RUN: ${TRAVIS_BUILD_DIR}/travis/after_success/docker-image-push-public.sh ${tag}"
	    ${TRAVIS_BUILD_DIR}/travis/after_success/docker-image-push-public.sh ${tag}
	fi

	echo "ABOUT TO RUN: ${TRAVIS_BUILD_DIR}/travis/after_success/docker-image-push-private.sh ${tag}"
	${TRAVIS_BUILD_DIR}/travis/after_success/docker-image-push-private.sh ${tag}
fi
