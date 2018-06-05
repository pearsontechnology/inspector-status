#!/bin/bash

IMAGE_TEMPLATE_LAST_COMMIT=$(git log -n 1 --pretty=oneline)

cat repos.txt | while read repo;
do
  echo -e "\nABOUT TO UPDATE ${repo}"
  git clone git@github.com:pearsontechnology/${repo}.git
  mkdir -p ${repo}/travis
  mkdir -p ${repo}/travis/script
  mkdir -p ${repo}/test/vulnerabilty_scan

  cp ../docker-compose.example.yml ${repo}
  cp ../docker-compose-test.example.yml ${repo}
  cp ../docker-compose-vulnerability-scan.yaml ${repo}
  cp after_success/docker-image-push-public.sh ${repo}/travis/after_success/
  cp after_success/docker-image-push-private.sh ${repo}/travis/after_success/
  cp after_success/after_success.sh ${repo}/travis/after_success/
  cp after_success/git-tag-version.sh ${repo}/travis/after_success/

  cp ../Makefile ${repo}
  cp ../README_TEMPLATE.md.j2 ${repo}
  cp ../readme_generate.sh ${repo}
  cd ${repo} && make readme && cd -

  cp ../.travis.yml ${repo}
  cp ../.lgtm ${repo}
  cp travis_rw_key.sh ${repo}/travis
  cp ../test/vulnerabilty_scan/get_twistlock_creds.sh ${repo}/test/vulnerabilty_scan/
  cp ../vulnerability_scan.sh ${repo}
  cp script/v_scan.sh ${repo}/travis/script/
  cp install/dependencies.sh ${repo}/travis/install/
  (cd ${repo} && git add . && git commit . -m "Update from image-template repo: ${IMAGE_TEMPLATE_LAST_COMMIT}" && git push)
  echo -e "FINISHED UPDATING ${repo}\n"
done

rm -fr image-*