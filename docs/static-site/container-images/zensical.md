# sommerfeldio/zensical

This image is used to build documentation sites using [Zensical](https://zensical.org), the Rust-based successor to MkDocs and Material for MkDocs. It is intended as the long-term replacement for [`sommerfeldio/mkdocs`](https://sommerfeld-io.github.io/container-images/container-images/mkdocs), which is now deprecated.

- [sommerfeldio/zensical](https://hub.docker.com/r/sommerfeldio/zensical) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/zensical) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/CONTRIBUTING.md)
- [Vulnerability Report](https://sommerfeld-io.github.io/container-images/cve/) with the known vulnerabilities of this image (`edge` and `latest`)

## Software Tags and Versioning

Learn about our tagging policy and the difference between rolling tags and immutable tags [on our documentation page⁠](https://github.com/sommerfeld-io/.github/blob/main/docs/tags-and-versions.md).

## About Zensical

[Material for MkDocs](https://squidfunk.github.io/mkdocs-material) is built on top of MkDocs, which has been unmaintained since August 2024. Rather than fork MkDocs, the Material for MkDocs team [announced Zensical](https://squidfunk.github.io/mkdocs-material/blog/2025/11/05/zensical/) - a ground-up, Rust-based rewrite that consolidates static site generation, theming, and customization into one coherent stack, free of the MkDocs dependency.

- Zensical website: <https://zensical.org>
- Zensical compatibility overview: <https://zensical.org/compatibility>
- Zensical documentation: <https://zensical.org/docs>

## Usage

This image can be used as a drop-in replacement for `sommerfeldio/mkdocs` and automatically reads your existing `mkdocs.yml` configuration. However, going forward, it is recommended to migrate to `zensical.toml` as the native configuration format.

This image supports two modes, mirroring `sommerfeldio/mkdocs`. The `build` command builds the documentation site and then the container terminates. The `serve` command starts a development preview server. Unlike `sommerfeldio/mkdocs`, `zensical serve` binds to `localhost:8000` by default; this image's default command already passes `--dev-addr 0.0.0.0:8000` so port-mapping from Docker works out of the box.

The development server is not recommended for production use. For production use, the `build` command should be used to generate the static site, which can then be served by a web server like [nginx](https://hub.docker.com/_/nginx) or [Apache httpd](https://hub.docker.com/_/httpd).

### Native config, using `zensical.toml`

```yaml
services:

  docs-build:
    container_name: docs-build
    image: &docs-image sommerfeldio/zensical:latest
    volumes: &volumes
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - .:/workspaces/your-project
    working_dir: &default-workdir /workspaces/your-project
    command: build

  docs-dev-server:
    container_name: docs-dev-server
    image: *docs-image
    volumes: *volumes
    working_dir: *default-workdir
    ports:
      - 8000:8000
```

### Compatibility layer, using `mkdocs.yml`

Zensical's native configuration format is `zensical.toml`. Going forward, that is the normal way to configure a site built with this image. Zensical also natively reads `mkdocs.yml` and reproduces the same HTML output, so an `mkdocs.yml`-based project keeps working through a compatibility layer while you migrate on your own schedule. There are two supported paths.

If both `mkdocs.yml` and `zensical.toml` exist in the same directory, `zensical.toml` wins automatically with no flag needed. To force a specific file regardless of what else is present, pass `-f` / `--config-file` explicitly, e.g. `command: build -f mkdocs.yml`.

For general getting-started information, see the official [Zensical "Get started" guide](https://zensical.org/docs/get-started/).

## Software Bill of Materials (SBOM)

Every image comes with a Software Bill of Materials (SBOM) in [SPDX](https://spdx.dev) JSON format, one per platform (`linux/amd64`, `linux/arm64`). The SBOM is created with [syft](https://github.com/anchore/syft) at build time and attached to the image on Docker Hub as an attestation. It is available for `edge`, `latest` and every version tag and always matches the image digest the tag points to.

All you need is Docker with the [buildx plugin](https://github.com/docker/buildx). Pulling the image is not required.

```bash
# Show the SBOM of all platforms
docker buildx imagetools inspect sommerfeldio/zensical:latest --format '{{ json .SBOM }}'

# Save the SBOM of one platform as a file
docker buildx imagetools inspect sommerfeldio/zensical:latest --format '{{ json (index .SBOM "linux/amd64").SPDX }}' > zensical-amd64.spdx.json
```

For a specific version, replace `latest` with the version tag, e.g. `sommerfeldio/zensical:1.0.0`. As an alternative, `docker scout sbom sommerfeldio/zensical:latest` shows the SBOM as well.

The [Vulnerability Report](https://sommerfeld-io.github.io/container-images/cve/) shows the known vulnerabilities of the `edge` and `latest` tags of all images, based on these SBOMs. It is updated daily.

## Known limitations

- **No official Kroki support (for now).** The [`mkdocs-kroki-plugin`](https://pypi.org/project/mkdocs-kroki-plugin) is not one of Zensical's [officially supported plugins](https://zensical.org/compatibility/plugins). Fenced diagram blocks (for example ` ```kroki-plantuml `) render as plain code blocks showing the raw diagram markup, not as an image. This is a known, accepted gap for the initial version of this image, tracked for a future update once Zensical's third-party module API is public.

## Support for the Packaged Software

We publish this image so you can conveniently use the tool or collection of tools inside it. We maintain the image itself, but we do not maintain the packaged tools and do not provide support for the software inside the container. Please report issues with a tool to its upstream project.

## License

This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/license).

The license from this GitHub repository is compatible with the [license from the zensical/zensical project](https://github.com/zensical/zensical/blob/master/LICENSE.md) (which is MIT as well).
