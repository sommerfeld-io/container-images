# sommerfeldio/revealjs

The `sommerfeldio/revealjs` image is a utility Docker image used to render [RevealJS](https://revealjs.com) presentations based on Markdown files and HTML templates.

The image is based on the [Docker Hardened Image](https://docs.docker.com/dhi/) `dhi.io/node` (Alpine). It uses the minimal runtime variant without shell or package manager and runs as a non-root user (UID `1000`).

- [sommerfeldio/revealjs](https://hub.docker.com/r/sommerfeldio/revealjs) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/revealjs) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/CONTRIBUTING.md)
- [Vulnerability Report](https://sommerfeld-io.github.io/container-images/cve/) with the known vulnerabilities of this image (`edge` and `latest`)

## Software Tags and Versioning

Learn about our tagging policy and the difference between rolling tags and immutable tags [on our documentation page⁠](https://github.com/sommerfeld-io/.github/blob/main/docs/tags-and-versions.md).

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

## Software Bill of Materials (SBOM)

Every image comes with a Software Bill of Materials (SBOM) in [SPDX](https://spdx.dev) JSON format, one per platform (`linux/amd64`, `linux/arm64`). The SBOM is created with [syft](https://github.com/anchore/syft) at build time and attached to the image on Docker Hub as an attestation. It is available for `edge`, `latest` and every version tag (starting with `0.25.2`) and always matches the image digest the tag points to.

All you need is Docker with the [buildx plugin](https://github.com/docker/buildx). Pulling the image is not required.

```bash
# Show the SBOM of all platforms
docker buildx imagetools inspect sommerfeldio/revealjs:latest --format '{{ json .SBOM }}'

# Save the SBOM of one platform as a file
docker buildx imagetools inspect sommerfeldio/revealjs:latest --format '{{ json (index .SBOM "linux/amd64").SPDX }}' > revealjs-amd64.spdx.json
```

For a specific version, replace `latest` with the version tag, e.g. `sommerfeldio/revealjs:0.25.2`. As an alternative, `docker scout sbom sommerfeldio/revealjs:latest` shows the SBOM as well.

The [Vulnerability Report](https://sommerfeld-io.github.io/container-images/cve/) shows the known vulnerabilities of the `edge` and `latest` tags of all images, based on these SBOMs. It is updated daily.

## How to Build Locally

To build the image locally, run:

```bash
cd components/revealjs # if from the root of the repository
docker build -t local/revealjs:dev .
```

Alternatively, use the project's `task` workflow:

```bash
task build:revealjs
```

## Support for the Packaged Software

We publish this image so you can conveniently use the tool or collection of tools inside it. We maintain the image itself, but we do not maintain the packaged tools and do not provide support for the software inside the container. Please report issues with a tool to its upstream project.

## License

This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/license).

The license from this GitHub repository is compatible with the [license from the reveal.js project](https://github.com/hakimel/reveal.js/blob/master/LICENSE) which is MIT as well.
