#!/usr/bin/env bash

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

: "${IMAGE:?Please set IMAGE env variable.}"
: "${VERSION:?Please set VERSION env variable.}"
TAG="${IMAGE}:${VERSION}"

# Build image
echo "Building '${TAG}' ... "
docker build . \
    --no-cache \
    -t "$TAG" \
    --build-arg VERSION=$VERSION
echo "Done"

# Add aditional tags
image_id=$(docker images ${TAG} --format "{{.ID}}")
for extra_tag in ${EXTRA_TAGS//;/$'\n'}
do
    if [ "$extra_tag" ]; then
        docker tag $image_id "${IMAGE}:${extra_tag}"
        echo "Added tag '${IMAGE}:${extra_tag}'"
    fi
done