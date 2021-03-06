# SRT library Docker image

[![Build Status](https://travis-ci.org/docker-live-stream-srv/docker-srt.svg?branch=master)](https://travis-ci.org/docker-live-stream-srv/docker-srt)
[![](https://img.shields.io/docker/image-size/livestreamsrv/srt/alpine-latest?label=alpine-latest)](https://hub.docker.com/r/livestreamsrv/srt/tags)
[![](https://img.shields.io/docker/image-size/livestreamsrv/srt/ubuntu-latest?label=ubuntu-latest)](https://hub.docker.com/r/livestreamsrv/srt/tags)
[![](https://img.shields.io/docker/image-size/livestreamsrv/srt/debian-latest?label=debian-latest)](https://hub.docker.com/r/livestreamsrv/srt/tags)


Docker image of [Haivision/srt](https://github.com/Haivision/srt) library and utils.

This image can be used as base to build an app using SRT library.

Maybe you are looking for [docker-srt-live-server](https://github.com/docker-live-stream-srv/docker-srt-live-server), server based on SRT library.

### Builded files
```
/opt/srt/lib/libsrt.so.x.x.x
/opt/srt/lib/libsrt.so.x
/opt/srt/lib/libsrt.so
/opt/srt/lib/libsrt.a

/opt/srt/include/srt/version.h
/opt/srt/include/srt/srt.h
/opt/srt/include/srt/logging_api.h
/opt/srt/include/srt/platform_sys.h
/opt/srt/include/srt/udt.h
/opt/srt/include/srt/srt4udt.h

/opt/srt/lib/pkgconfig/haisrt.pc
/opt/srt/lib/pkgconfig/srt.pc

/opt/srt/bin/srt-live-transmit
/opt/srt/bin/srt-file-transmit
/opt/srt/bin/srt-tunnel
/opt/srt/bin/srt-ffplay
```
