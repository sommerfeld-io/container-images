FROM squidfunk/mkdocs-material:9.5.39
LABEL maintainer="sebastian@sommerfeld.io"

ARG COMMIT_SHA=undefined

LABEL org.opencontainers.image.version="$COMMIT_SHA"
LABEL org.opencontainers.image.revision="$COMMIT_SHA"
LABEL org.opencontainers.image.vendor="sommerfeld-io"
LABEL org.opencontainers.image.title="mkdocs"
LABEL org.opencontainers.image.description="Build the documentation using the mkdocs toolchain"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/sommerfeldio/mkdocs"
LABEL org.opencontainers.image.documentation="https://sommerfeld-io.github.io/container-images/images/mkdocs"
LABEL org.opencontainers.image.source="https://github.com/sommerfeld-io/container-images/tree/main/components/mkdocs"

RUN pip install --no-cache-dir mkdocs-kroki-plugin==0.9.0
