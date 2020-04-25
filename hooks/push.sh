#!/usr/bin/env bash

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

: "${DOCKER_USERNAME:?Please set DOCKER_USERNAME env variable.}"
: "${DOCKER_TOKEN:?Please set DOCKER_TOKEN env variable.}"
echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Push each tag
ALL_TAGS="${VERSION};${EXTRA_TAGS}"
for current_tag in ${ALL_TAGS//;/$'\n'}
do
    if [ "$current_tag" ]; then
        echo "Pushing tag '${IMAGE}:${current_tag}' ..."
        docker push  "${IMAGE}:${current_tag}"
    fi
done