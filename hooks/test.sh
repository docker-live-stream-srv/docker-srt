#!/usr/bin/env bash

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

: "${BASE_IMAGE:?Please set BASE_IMAGE env variable.}"
: "${IMAGE:?Please set IMAGE env variable.}"
: "${VERSION:?Please set VERSION env variable.}"
TAG="${IMAGE}:${BASE_IMAGE}-${VERSION}"
SCRIPT_DIR=$(dirname "$0")
SRC_DIR=$(realpath "$SCRIPT_DIR/../")
TESTS_DIR="${SRC_DIR}/tests"

args=""
for file in ${TESTS_DIR}/*.yml; do
   args="${args} --config ${file}"
done 

echo "Runing tests ..."
container-structure-test test --image "${TAG}" $args
echo "Done"
