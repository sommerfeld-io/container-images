# sommerfeldio/devcontainer

The `sommerfeldio/devcontainer` Docker image serves as a foundational development environment for projects under the [sommerfeld.io](https://github.com/sommerfeld-io) organization. It includes essential tools required by all repositories. It can be used as either a ready-to-use development container for immediate coding, or as a base image that can be extended with additional tools as needed.

- [sommerfeldio/devcontainer](https://hub.docker.com/r/sommerfeldio/devcontainer) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/devcontainer) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/CONTRIBUTING.md)
- Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

## Software Tags and Versioning

Learn about our tagging policy and the difference between rolling tags and immutable tags [on our documentation page⁠](https://github.com/sommerfeld-io/.github/blob/main/docs/tags-and-versions.md).

### Software Bill of Materials (SBOM)

Starting with version 0.25.2, a Software Bill of Materials (SBOM) in SPDX format is generated for every image at build time and attached directly to the image in Docker Hub as an OCI attestation, available for the `edge`, `latest` and versioned tags. Retrieve it with

- `docker scout sbom sommerfeldio/devcontainer:latest` or
- `docker buildx imagetools inspect sommerfeldio/devcontainer:latest --format "{{ json .SBOM }}"`.

The same SBOM is also attached as a downloadable asset on each [GitHub release](https://github.com/sommerfeld-io/container-images/releases).

## Usage

Three image variants are published from the same Dockerfile, one stage per variant:

- The `base` stage is published as `sommerfeldio/devcontainer:<version>`, `:edge`, and `:latest` and provides the default development environment.
- The `ansible` stage is published as `sommerfeldio/devcontainer:<version>-ansible`, `:edge-ansible`, and `:latest-ansible` and adds `ansible-dev-tools` on top of the `base` stage, including tools such as `ansible-playbook`, `ansible-lint`, `ansible-navigator`, and `molecule` on `PATH`.
- The `go` stage is published as `sommerfeldio/devcontainer:<version>-go`, `:edge-go`, and `:latest-go` and adds the Go toolchain, `gopls`, `dlv`, and `build-essential` on top of the `base` stage for Go development.

Both variants are based on Microsoft's [`mcr.microsoft.com/devcontainers/base:resolute`](https://mcr.microsoft.com/en-us/product/devcontainers/base/about) image, which tracks the current Ubuntu LTS base image published by Microsoft Dev Containers. They are configured to run as the non-root user `vscode` by default. File permissions and mounted volumes will be owned and accessed by the `vscode` user (uid = `1000`, gid = `1000`).

The easiest way to use either variant is by adding a Dockerfile to your repository's `.devcontainer` folder and extending the matching `sommerfeldio/devcontainer` tag. This approach provides several benefits:

- Ensures that pipelines can validate the Devcontainer setup.
- Allows Dependabot to track updates.
- Makes it easy to extend the image with additional tools as needed.

### Usage: Default Image (`base` stage)

Extend the plain `sommerfeldio/devcontainer` tag for the default development environment:

```Dockerfile
FROM sommerfeldio/devcontainer:latest
LABEL maintainer="sebastian@sommerfeld.io"
```

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
        "ghcr.io/devcontainers/features/docker-in-docker:4.0.0": {
            "moby": false
        }
    }
}
```

### Usage: Ansible Variant (`ansible` stage)

If you need the Ansible tooling, extend the published `-ansible` tag instead:

```Dockerfile
FROM sommerfeldio/devcontainer:latest-ansible
LABEL maintainer="sebastian@sommerfeld.io"
```

The `.devcontainer/devcontainer.json` shown above works unchanged for this variant. In addition to everything in the `base` stage, the `ansible` stage puts `ansible-dev-tools` (`ansible-playbook`, `ansible-lint`, `ansible-navigator`, `molecule`, and related tools) on `PATH`.

### Usage: Go Variant (`go` stage)

If you need Go tooling, extend the published `-go` tag instead:

```Dockerfile
FROM sommerfeldio/devcontainer:latest-go
LABEL maintainer="sebastian@sommerfeld.io"
```

The `.devcontainer/devcontainer.json` shown above works unchanged for this variant. In addition to everything in the `base` stage, the `go` stage provides the Go toolchain plus `gopls`, `dlv`, and `build-essential` on `PATH` for Go development, debugging, and CGO-based builds.

## How to Build

Use the repository's canonical `task` workflow to build the published variants locally:

```bash
task build:devcontainer

task build:devcontainer-ansible

task build:devcontainer-go
```

The underlying Dockerfile exposes explicit `base`, `ansible`, and `go` stages. Equivalent raw Docker commands are shown below using the repository's local tagging convention (`local/devcontainer:dev`, `local/devcontainer:dev-ansible`, and `local/devcontainer:dev-go`):

To build the default image from the explicit `base` stage locally, run:

```bash
docker build -f components/devcontainer/Dockerfile --target base -t local/devcontainer:dev components/devcontainer
```

To build the published Ansible variant from the explicit `ansible` stage locally, run:

```bash
docker build -f components/devcontainer/Dockerfile --target ansible -t local/devcontainer:dev-ansible components/devcontainer
```

To build the published Go variant from the explicit `go` stage locally, run:

```bash
docker build -f components/devcontainer/Dockerfile --target go -t local/devcontainer:dev-go components/devcontainer
```

## License

This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/license).

The license from this GitHub repository is compatible with the [license from the devcontainers project](https://github.com/devcontainers/images/blob/main/LICENSE) which is MIT as well.
