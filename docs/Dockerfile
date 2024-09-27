# @file Dockerfile
# @brief Dockerfile for building the documentation
#
# @description
# This Dockerfile is used to build the documentation using the `mkdocs` toolchain. A dedicated
# Dockerfile is needed because the base image does not provide all necessary plugins and tools.

FROM squidfunk/mkdocs-material:9.5.38
LABEL maintainer="sebastian@sommerfeld.io"

RUN pip install --no-cache-dir mkdocs-kroki-plugin==0.9.0
