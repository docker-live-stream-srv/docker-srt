#!/usr/bin/env bash

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

# Download srt
mkdir -p /tmp/srt/build
echo "Downloading '$DOWNLOAD_URL' ..."
wget -qO- $DOWNLOAD_URL | tar -xvz -C /tmp/srt --strip-components=1

# Switch to build dir
cd /tmp/srt/build

# Compile srt
cmake -G "Unix Makefiles" \
    -DCMAKE_INSTALL_BINDIR="$PREFIX/bin" \
    -DCMAKE_INSTALL_INCLUDEDIR="$PREFIX/include" \
    -DCMAKE_INSTALL_LIBDIR="$PREFIX/lib" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    ..
make && make install

# Collect required libraries
mkdir -p $PREFIX/lib-used
(
    ldd $PREFIX/bin/srt-live-transmit && \
    ldd $PREFIX/bin/srt-file-transmit &&  \
    ldd $PREFIX/bin/srt-tunnel \
) | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -u -v '{}' $PREFIX/lib-used
cp -f $PREFIX/lib-used/* $PREFIX/lib
rm -rf $PREFIX/lib-used