# sommerfeldio/mkdocs

This image is used to build the documentation using the `mkdocs` toolchain and is based on [Material for MkDocs](https://squidfunk.github.io/mkdocs-material).

This image extends the [squidfunk/mkdocs-material](https://hub.docker.com/r/squidfunk/mkdocs-material) image with the [mkdocs-kroki-plugin](https://pypi.org/project/mkdocs-kroki-plugin) to allow rendering diagrams and charts using [Kroki.io](https://kroki.io). A dedicated Dockerfile is needed because the base image does not provide all necessary plugins and tools.

- [sommerfeldio/mkdocs](https://hub.docker.com/r/sommerfeldio/mkdocs) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/mkdocs) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/docs/contribute.md)
- Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

## Usage

This image supports two modes. The `build` command is used to build the documentation site based on your Markdown docs. The container terminates after the build is complete. Additionally the image offers a development server to preview the documentation site. Both features originate in the [squidfunk/mkdocs-material](https://hub.docker.com/r/squidfunk/mkdocs-material) base image.

```yaml
services:

  docs-build:
    container_name: docs-build
    image: &docs-image sommerfeldio/mkdocs:latest
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
      - 3080:8000
```

The development server is not recommended for production use. It is intended to be used during the development of the documentation site. For production use, the `build` command should be used to generate the static site. This triggers the production-level compilation and minification of all style sheets and JavaScript files. The resulting static site can be served by a web server like [nginx](https://hub.docker.com/_/nginx) or [Apache httpd](https://hub.docker.com/_/httpd).

For information on how to get started with [Material for MkDocs](https://squidfunk.github.io/mkdocs-material), please refer to the [official "Getting started" guide of the projects documentation](https://squidfunk.github.io/mkdocs-material/getting-started).

For information on how to configure the mkdocs-kroki-plugin, please refer to the [official documentation of the plugin](https://pypi.org/project/mkdocs-kroki-plugin).

## License

This container image is inheriting the [MIT License from the GitHub repository](ttps://sommerfeld-io.github.io/container-images/license).

The license from this GitHub repository is compatible with the [license from the squidfunk/mkdocs-material project](https://github.com/squidfunk/mkdocs-material/blob/master/LICENSE) (which is MIT as well).
