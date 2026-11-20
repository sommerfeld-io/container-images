FROM dhi.io/node:26.13.1-alpine3.24-dev AS base
LABEL maintainer="sebastian@sommerfeld.io"

WORKDIR /work
RUN git clone https://github.com/hakimel/reveal.js.git

WORKDIR /work/reveal.js
RUN PUPPETEER_SKIP_DOWNLOAD=true npm install


FROM dhi.io/node:26.13.1-alpine3.24 AS serve
LABEL maintainer="sebastian@sommerfeld.io"

COPY --from=base --chown=1000:1000 /work /work

WORKDIR /work/reveal.js
EXPOSE 8000
ENTRYPOINT [ "node", "node_modules/vite/bin/vite.js", "--host=0.0.0.0" ]
