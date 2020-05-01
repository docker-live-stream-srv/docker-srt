#!/usr/bin/env bash

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

: "${BASE_IMAGE:?Please set BASE_IMAGE env variable.}"
SCRIPT_DIR=$(dirname "$0")
SRC_DIR=$(realpath "$SCRIPT_DIR/../")
exec docker run --rm -it -v "${SRC_DIR}:/src" hadolint/hadolint hadolint -c /src/.hadolint.yml /src/Dockerfile.${BASE_IMAGE}