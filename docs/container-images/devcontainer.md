# sommerfeldio/devcontainer

The `sommerfeldio/devcontainer` Docker image serves as a foundational development environment for projects under the [sommerfeld.io](https://github.com/sommerfeld-io) organization. It includes essential tools required by all repositories. It can be used as either a ready-to-use development container for immediate coding. or as a baseline image that can be extended with additional tools as needed.

- [sommerfeldio/devcontainer](https://hub.docker.com/r/sommerfeldio/devcontainer) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/devcontainer) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/CONTRIBUTING.md)
- Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

## Software Tags and Versioning

Learn about our tagging policy and the difference between rolling tags and immutable tags [on our documentation page⁠](https://github.com/sommerfeld-io/.github/blob/main/docs/tags-and-versions.md).

## Usage

The easiest way to use this image is by adding a Dockerfile to your repository's `.devcontainer` folder and extending `sommerfeldio/devcontainer`.

```Dockerfile
FROM sommerfeldio/devcontainer:latest
LABEL maintainer="sebastian@sommerfeld.io"
```

This `sommerfeldio/devcontainer` image is based on [`mcr.microsoft.com/devcontainers/base:ubuntu-24.04`](https://hub.docker.com/r/microsoft/devcontainers) and is configured to run as the non-root user `vscode` by default. File permissions and mounted volumes will be owned and accessed by the `vscode` user (uid = `1000`, gid = `1000`).

```json
{
    "name": "project-name",
    "build": {
        "dockerfile": "Dockerfile"
    },

    "customizations": {
        "vscode": {
            "settings": {},
            "extensions": [
                "ms-azuretools.vscode-docker",
                "github.vscode-github-actions",
                "redhat.vscode-yaml"
            ]
        }
    },

    "features": {
        "ghcr.io/devcontainers/features/docker-in-docker:2.12.0": {}
    }
}
```

This approach provides several benefits:

- Ensures that pipelines can validate the Devcontainer setup.
- Allows Dependabot to track updates.
- Makes it easy to extend the image with additional tools as needed.

## License

This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/license).

The license from this GitHub repository is compatible with the [license from the devcontainers project](https://github.com/devcontainers/images/blob/main/LICENSE) which is MIT as well.
