# WARNING: This file is deployed from template. Raise a pull request against image-template to change.

SHELL := /bin/bash
IMAGE := $(notdir $(CURDIR))
DOMAIN := .localstack.local
THIS_FILE := $(lastword $(MAKEFILE_LIST))
TEST_DIR := $(firstword $(wildcard $(CURDIR)/test))
PRE_BUILD_SCRIPT := $(firstword $(wildcard $(CURDIR)/pre_build.sh))

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: pre_build config test  ## Runs config and test

clean:  ## Kills container and leaves image for this module
	@echo "Killing Container(s)"
	bash -c "COMPOSE_PROJECT_NAME=$(IMAGE)-dev docker-compose -f docker-compose.yml down"
	bash -c "COMPOSE_PROJECT_NAME=$(IMAGE)-test docker-compose -f docker-compose-test.yml down"

pre_build:  ## Execs any IDEMPOTENT actions that need to occur before building the image
    ifeq ($(PRE_BUILD_SCRIPT),)
	@echo "No Prebuild script found. Skipping pre build step"
    else
	bash -c "./pre_build.sh $(IMAGE)"
    endif

config:  ## Build the application container
	@echo "Building application container"
	bash -c "COMPOSE_PROJECT_NAME=$(IMAGE)-dev docker-compose -f docker-compose.yml up  --build -d"

test:  ## Execs into the container, and runs inspec tests
    ifeq ($(TEST_DIR),)
	@echo "NO TEST FOLDER FOUND. Skipping tests!"
    else
	${MAKE} test_exec || ${MAKE} test_cleanup
    endif

test_exec:  ## Execs into the container, and runs inspec tests
	@echo "Running Tests"
	bash -c "COMPOSE_PROJECT_NAME=$(IMAGE)-test docker-compose -f docker-compose-test.yml up --build -d"
	@bash -c "docker cp $(CURDIR)/test $(IMAGE)-test:/tmp/"
	bash -c "sleep 4"
	bash -c "docker exec -ti $(IMAGE)-test inspec exec /tmp/test/inspec"
	bash -c "COMPOSE_PROJECT_NAME=$(IMAGE)-test docker-compose -f docker-compose-test.yml down"
	exit 0

test_cleanup:  ## Cleans up if tests fail
	@echo "Tests failed. Running cleanup"
	bash -c "COMPOSE_PROJECT_NAME=$(IMAGE)-test docker-compose -f docker-compose-test.yml down"
	exit 1

v_scan:  ## Runs vulnerability scan against current image
	${MAKE} v_scan_exec || ${MAKE} v_scan_cleanup

v_scan_exec:  ## Runs vulnerabilty_scan on current state of the image
	@echo "Running Vulnerablity Scan"
	bash -c "docker build -t \"twistlock-temp-scan/$(IMAGE)-temp-tag\" ."
	bash -c "./vulnerability_scan.sh $(IMAGE)"
	bash -c "sleep 4"
	bash -c "COMPOSE_PROJECT_NAME=$(IMAGE)-scan docker exec -ti pearson-image-vulnerability-scan /usr/bin/twistcli_wrapper.sh env_agrs"
	bash -c "COMPOSE_PROJECT_NAME=$(IMAGE)-scan docker-compose -f docker-compose-vulnerability-scan.yaml down"
	bash -c "docker rmi twistlock-temp-scan/$(IMAGE)-temp-tag"
	exit 0

v_scan_cleanup:  ## Cleans up if scan fail
	@echo "Tests failed. Running cleanup"
	bash -c "COMPOSE_PROJECT_NAME=$(IMAGE)-scan docker-compose -f docker-compose-vulnerability-scan.yaml down"
	bash -c "docker rmi twistlock-temp-scan/$(IMAGE)-temp-tag"
	exit 1

status:  ## Lists the docker container for this module
	bash -c "docker ps --filter name=$(IMAGE)"

ssh:  ## Execs into bash on the container for this module
	bash -c "docker exec -ti $(IMAGE) /bin/bash"

readme:  ## Regenerates the README.md using the included templates
	@echo "Generating README.md"
	bash -c "./readme_generate.sh $(IMAGE)"



.DEFAULT_GOAL := all
.PHONY: all clean build run config test ssh
