# sommerfeldio/mkdocs

This Dockerfile is used to build the documentation using the `mkdocs` toolchain. A dedicated Dockerfile is needed because the base image does not provide all necessary plugins and tools. This image extends the [squidfunk/mkdocs-material](https://hub.docker.com/r/squidfunk/mkdocs-material) base image with the [mkdocs-kroki-plugin](https://pypi.org/project/mkdocs-kroki-plugin) to allow rendering diagrams and charts using [Kroki.io](https://kroki.io).

- [sommerfeldio/mkdocs](https://hub.docker.com/r/sommerfeldio/mkdocs) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/mkdocs) on GitHub
- [How to Contribute](https://sommerfeld-io.github.io/container-images/about/contribute)
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

## License
This container image is inheriting the [License from the GitHub repository](https://sommerfeld-io.github.io/container-images/about/license).
