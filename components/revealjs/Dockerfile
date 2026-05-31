FROM node:26.2.0-alpine AS base
LABEL maintainer="sebastian@sommerfeld.io"

RUN apk add --no-cache git

WORKDIR /work
RUN git clone https://github.com/hakimel/reveal.js.git

WORKDIR /work/reveal.js
RUN npm install


FROM base AS pdf
ARG USERNAME=revealjs
RUN apk add --no-cache chromium ttf-freefont \
    && npm install --global decktape http-server \
    && addgroup -S "$USERNAME" \
    && adduser -S -G "$USERNAME" "$USERNAME" \
    && mkdir -p /output \
    && chmod 1777 /output \
    && if [ -x /usr/bin/chromium-browser ]; then ln -sf /usr/bin/chromium-browser /usr/local/bin/chromium-headless; else ln -sf /usr/bin/chromium /usr/local/bin/chromium-headless; fi

COPY export-pdf.sh /usr/local/bin/export-pdf.sh

RUN chmod +x /usr/local/bin/export-pdf.sh

USER "$USERNAME"
ENTRYPOINT [ "/usr/local/bin/export-pdf.sh" ]


FROM base AS serve
ENTRYPOINT [ "npm", "start", "--", "--host=0.0.0.0" ]
