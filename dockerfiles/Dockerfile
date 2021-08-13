

FROM scratch

MAINTAINER loren.lisk@liskl.com

ARG RELEASE_VERSION=unknown
ARG BRANCH=unknown
ENV COMMIT_SHA=$RELEASE_VERSION
ENV BRANCH=$BRANCH

ARG ARCH=
ARG ALPINE_VERSION=

#ENV alpine_version 3.11.3
#ENV ARCH x86_64

ADD ./rootfs/alpine-minirootfs-${ALPINE_VERSION}-${ARCH}.tar.gz /

RUN echo -ne "BASE_BRANCH=BRANCH\nBASE_SHA=$COMMIT_SHA\n" > /etc/build_release

ENTRYPOINT ["/bin/sh"]
