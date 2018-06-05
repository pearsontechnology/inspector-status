#!/bin/bash

# WARNING: This file is deployed from template. Raise a pull request against image-template to change.

set -x

echo "Running Vulnerability Tests"

make v_scan || true
export TEST_EXIT_CODE=$?
exit ${TEST_EXIT_CODE}