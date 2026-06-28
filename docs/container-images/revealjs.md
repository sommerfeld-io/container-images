# sommerfeldio/revealjs

The `sommerfeldio/revealjs` image is a utility Docker image used to render [RevealJS](https://revealjs.com) presentations based on Markdown files and HTML templates.

- [sommerfeldio/revealjs](https://hub.docker.com/r/sommerfeldio/revealjs) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/revealjs) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/CONTRIBUTING.md)
- Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

## Software Tags and Versioning

Learn about our tagging policy and the difference between rolling tags and immutable tags [on our documentation page⁠](https://github.com/sommerfeld-io/.github/blob/main/docs/tags-and-versions.md).

Starting with version 0.22.0, a Software Bill of Materials (SBOM) in SPDX format is generated for every image and attached to each [GitHub release](https://github.com/sommerfeld-io/container-images/releases) as a downloadable asset.

## Usage

RevealJS supports rendering presentations based on Markdown files which we find the most convenient way to create slides.

To serve a presentation based on your own `index.html` and Markdown files and monitor source files for changes, you can use the following `docker run` command:

```bash
docker run --rm -it -p 8000:8000 \
    --volume "$(pwd)/index.html:/work/reveal.js/index.html" \
    --volume "$(pwd)/slides:/work/reveal.js/slides" \
    sommerfeldio/revealjs:latest
```

Alternatively, you can use Docker Compose with the following service definition:

```yaml
services:
  revealjs:
    image: sommerfeldio/revealjs:latest
    ports:
      - 8000:8000
    volumes:
      - ./index.html:/work/reveal.js/index.html
      - ./slides:/work/reveal.js/slides
```

You need to override the default `index.html`. For your Markdown files, the most convenient way is to mount them into the `/work/reveal.js/slides` directory. This way, all resources are available in the container. See the [demo presentation](https://github.com/sommerfeld-io/container-images/tree/main/components/revealjs/demo) for an example.

Simply mounting all files from your (current) directory into `/work/reveal.js` will not work because this would override the default contents of `/work/reveal.js` including the necessary `node_modules` and dependencies. This is also the reason why you cannot change the working directory to another path.

> **NOTE:** RevealJS provides more ways to create presentations, e.g. by using only HTML files. But for us, Markdown is the most convenient way. So we focus on this method and did not put much effort into testing other methods.

### Convert presentation to PDF

To export a presentation with `docker run`, mount your `index.html`, slide assets, and an output directory. The following example writes the generated PDF to the current working directory while preserving the ownership of the user running Docker:

```bash
docker run --rm \
    --user "$(id -u):$(id -g)" \
    --volume "$(pwd)/index.html:/work/reveal.js/index.html" \
    --volume "$(pwd)/slides:/work/reveal.js/slides" \
    --volume "$(pwd):/output" \
    sommerfeldio/revealjs:latest-pdf /output/index.pdf
```

Alternatively, you can use Docker Compose:

```yaml
services:
  revealjs-pdf:
    image: sommerfeldio/revealjs:latest-pdf
    user: "${UID}:${GID}"
    volumes:
      - ./index.html:/work/reveal.js/index.html
      - ./slides:/work/reveal.js/slides
      - ./:/output
    command: /output/index.pdf
```

## How to Build

To build the standard presentation image locally, run:

```bash
cd components/revealjs # if from the root of the repository
docker build -t local/revealjs:dev .
```

To build the PDF image locally, run:

```bash
cd components/revealjs # if from the root of the repository
docker build --target pdf -t local/revealjs:dev-pdf .
```

Alternatively, use the project's `task` workflow for the standard image:

```bash
task build:revealjs

task build:revealjs-pdf
```

## License

This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/license).

The license from this GitHub repository is compatible with the [license from the reveal.js project](https://github.com/hakimel/reveal.js/blob/master/LICENSE) which is MIT as well.
