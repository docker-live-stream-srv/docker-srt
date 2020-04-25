###############################
# Build image
###############################
FROM alpine:3.11 as build

ARG VERSION=1.4.1
ENV SRT_DOWNLOAD_URL=https://github.com/Haivision/srt/archive/v${VERSION}.tar.gz
ENV PREFIX=/opt/srt
ENV LD_LIBRARY_PATH=${PREFIX}/lib
ENV PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
ENV MAKEFLAGS="-j8"

# Build dependencies
RUN apk add --no-cache \
  bash \
  build-base \
  coreutils \
  wget \
  gcc \
  cmake \
  openssl-dev

# Check errors in pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Download srt
RUN mkdir -p /tmp/srt/build && \
    wget -qO- $SRT_DOWNLOAD_URL | \
      tar -xvz -C /tmp/srt --strip-components=1

# Switch to build dir
WORKDIR /tmp/srt/build

# Compile srt
RUN cmake -G "Unix Makefiles" \
        -DCMAKE_INSTALL_BINDIR="$PREFIX/bin" \
        -DCMAKE_INSTALL_INCLUDEDIR="$PREFIX/include" \
        -DCMAKE_INSTALL_LIBDIR="$PREFIX/lib" \
        -DCMAKE_INSTALL_PREFIX="$PREFIX" \
        .. && \
    make && make install

# Collect required libraries
RUN mkdir -p $PREFIX/lib-used && \
    ( \
      ldd $PREFIX/bin/srt-live-transmit && \
      ldd $PREFIX/bin/srt-file-transmit &&  \
      ldd $PREFIX/bin/srt-tunnel \
    ) \
      | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -u -v '{}' $PREFIX/lib-used && \
    cp -f $PREFIX/lib-used/* $PREFIX/lib && \
    rm -rf $PREFIX/lib-used && \
    # Remove duplicate libs that are from musl and openssl packages
    rm -rf $PREFIX/lib/ld-musl* && \
    rm -rf $PREFIX/lib/libcrypto*

###############################
# Release image
###############################
FROM alpine:3.11

ENV PREFIX=/opt/srt
ENV PATH=$PREFIX/bin:$PATH
ENV LD_LIBRARY_PATH=/lib:$PREFIX/lib

RUN apk add --no-cache \
  bash \
  musl \
  openssl \
  ca-certificates

COPY --from=build /opt/srt /opt/srt

CMD ["bash"]