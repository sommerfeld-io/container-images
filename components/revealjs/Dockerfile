FROM dhi.io/node:26.13.1-alpine3.24-dev AS base
LABEL maintainer="sebastian@sommerfeld.io"

WORKDIR /work
RUN git clone https://github.com/hakimel/reveal.js.git

WORKDIR /work/reveal.js
RUN PUPPETEER_SKIP_DOWNLOAD=true npm install


FROM base AS pdf
ARG USERNAME=revealjs
RUN apk add --no-cache chromium ttf-freefont \
    && PUPPETEER_SKIP_DOWNLOAD=true npm install --global decktape http-server \
    && addgroup -S "$USERNAME" \
    && adduser -S -G "$USERNAME" "$USERNAME" \
    && mkdir -p /output \
    && chmod 1777 /output \
    && if [ -x /usr/bin/chromium-browser ]; then ln -sf /usr/bin/chromium-browser /usr/local/bin/chromium-headless; else ln -sf /usr/bin/chromium /usr/local/bin/chromium-headless; fi

COPY export-pdf.sh /usr/local/bin/export-pdf.sh

RUN chmod +x /usr/local/bin/export-pdf.sh

USER "$USERNAME"
ENTRYPOINT [ "/usr/local/bin/export-pdf.sh" ]


FROM dhi.io/node:26.13.1-alpine3.24 AS serve
LABEL maintainer="sebastian@sommerfeld.io"

COPY --from=base --chown=1000:1000 /work /work

WORKDIR /work/reveal.js
EXPOSE 8000
ENTRYPOINT [ "node", "node_modules/vite/bin/vite.js", "--host=0.0.0.0" ]
