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

# Determine version to download
if [ "$VERSION" = "dev-master" ]; then
    VERSION_ARG='master'
    DOWNLOAD_URL_ARG="https://github.com/Haivision/srt/archive/${VERSION_ARG}.tar.gz"
elif [ "$VERSION" = "latest" ]; then
    VERSION_ARG='latest'
    DOWNLOAD_URL_ARG=$(curl -s "https://api.github.com/repos/Haivision/srt/releases/latest" | grep tarball_url | cut -d '"' -f 4)
else
    VERSION_ARG="v$VERSION"
    DOWNLOAD_URL_ARG="https://github.com/Haivision/srt/archive/${VERSION_ARG}.tar.gz"
fi

# Build image
echo "Building '${TAG}' ... "
docker build -f Dockerfile.${BASE_IMAGE} . \
    --no-cache \
    -t "$TAG" \
    --build-arg VCS_URL=${VCS_URL}
    --build-arg VCS_REF=`git rev-parse --short HEAD`
    --build-arg VERSION=$VERSION_ARG \
    --build-arg DOWNLOAD_URL=$DOWNLOAD_URL_ARG
echo "Done"

# Add aditional tags
image_id=$(docker images ${TAG} --format "{{.ID}}")
EXTRA_TAGS=${EXTRA_TAGS:-}
for extra_tag in ${EXTRA_TAGS//;/$'\n'}
do
    if [ "$extra_tag" ]; then
        docker tag "$image_id" "${IMAGE}:${BASE_IMAGE}-${extra_tag}"
        echo "Added tag '${IMAGE}:${BASE_IMAGE}-${extra_tag}'"
    fi
done