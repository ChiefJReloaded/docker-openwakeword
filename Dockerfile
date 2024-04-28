# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG OPENWAKEWORD_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chiefj"

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libopenblas0 \
    python3-venv && \
  if [ -z ${OPENWAKEWORD_VERSION+x} ]; then \
    OPENWAKEWORD_VERSION=$(curl -sL  "https://api.github.com/repos/rhasspy/wyoming-openwakeword/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir \
    pip \
    wheel && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/ubuntu/ \
    "wyoming-openwakeword @ https://github.com/rhasspy/wyoming-openwakeword/archive/refs/tags/v${OPENWAKEWORD_VERSION}.tar.gz" && \
  rm -rf \
    /var/lib/apt/lists/* \
    /tmp/*

COPY root/ /

VOLUME /config

EXPOSE 10400
