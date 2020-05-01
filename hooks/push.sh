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

# All tags = version tag + extra tags
ALL_TAGS="${VERSION};${EXTRA_TAGS:-}"

for current_tag in ${ALL_TAGS//;/$'\n'}
do
    # Skip empty values
    if [ "$current_tag" ]; then
        full_tag="${IMAGE}:${BASE_IMAGE}-${current_tag}"
        echo "Pushing tag '$full_tag' ..."
        docker push  "$full_tag"

        # If tag="alpine-latest", push to "latest" too
        if [ "$full_tag" = "${IMAGE}:alpine-latest" ]; then
            image_id=$(docker images $full_tag --format "{{.ID}}")
            docker tag "$image_id" "${IMAGE}:latest"
            echo "Added tag '${IMAGE}:latest'"
            echo "Pushing tag '${IMAGE}:latest' ..."
            docker push "${IMAGE}:latest"
        fi
    fi
done