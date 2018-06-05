#!/bin/bash

eval `ssh-agent -s` > /dev/null 2>&1

ssh-add ~/.ssh/id_rsa > /dev/null 2>&1

# Don't version template changes
commit_message=$(git log --format=%B -n 1 ${TRAVIS_COMMIT} | head -1)
if [[ "$commit_message" == *"Update from image-template repo:"* ]]; then
  echo "Not versioning template update"
  exit 0
fi

prefix=$(cat ${TRAVIS_BUILD_DIR}/version.txt)

latest_tag=$(git ls-remote --tags origin | cut -f 3 -d '/' | grep "^${prefix}" | sort -t. -k 3,3nr | head -1)

if [ -z ${latest_tag} ]; then
  tag="${prefix}.0"
else
  tag="${latest_tag%.*}.$((${latest_tag##*.}+1))"
fi

git tag ${tag} > /dev/null 2>&1
git push --tags > /dev/null 2>&1

echo ${tag}
