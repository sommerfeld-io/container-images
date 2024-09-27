FROM ubuntu:24.04
LABEL maintainer="sebastian@sommerfeld.io"

RUN apt-get update \
    && apt-get install -y --no-install-recommends ncftp=2:3.2.6-1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
