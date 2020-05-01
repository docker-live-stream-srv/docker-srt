#!/usr/bin/env bash

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

: "${BASE_IMAGE:?Please set BASE_IMAGE env variable.}"
: "${IMAGE:?Please set IMAGE env variable.}"
: "${VERSION:?Please set VERSION env variable.}"
: "${DOCKER_USERNAME:?Please set DOCKER_USERNAME env variable.}"
: "${DOCKER_TOKEN:?Please set DOCKER_TOKEN env variable.}"
echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin

# If tag="alpine-latest", add tag "latest" too
if [ "${BASE_IMAGE}-${VERSION}" = "alpine-latest" ]; then
    EXTRA_TAGS="${EXTRA_TAGS:-};latest"
fi

# All tags = version tag + extra tags
ALL_TAGS="${VERSION};${EXTRA_TAGS:-}"

for current_tag in ${ALL_TAGS//;/$'\n'}
do
    # Skip empty values
    if [ "$current_tag" ]; then
        echo "Pushing tag '${IMAGE}:${BASE_IMAGE}-${current_tag}' ..."
        docker push  "${IMAGE}:${BASE_IMAGE}-${current_tag}"
    fi
done