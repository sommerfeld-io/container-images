# sommerfeldio/devcontainer

The `sommerfeldio/devcontainer` Docker image serves as a foundational development environment for projects under the [sommerfeld.io](https://github.com/sommerfeld-io) organization. It includes essential tools required by all repositories. It can be used as either a ready-to-use development container for immediate coding. or as a baseline image that can be extended with additional tools as needed.

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

Two image variants are published from the same Dockerfile:

- `sommerfeldio/devcontainer:<version>`, `:edge`, and `:latest` provide the baseline development environment.
- `sommerfeldio/devcontainer:<version>-ansible`, `:edge-ansible`, and `:latest-ansible` add `ansible-dev-tools` on top of the baseline image, including tools such as `ansible-playbook`, `ansible-lint`, `ansible-navigator`, and `molecule` on `PATH`.

The easiest way to use the baseline image is by adding a Dockerfile to your repository's `.devcontainer` folder and extending `sommerfeldio/devcontainer`.

```Dockerfile
FROM sommerfeldio/devcontainer:latest
LABEL maintainer="sebastian@sommerfeld.io"
```

This `sommerfeldio/devcontainer` image is based on Microsoft's [`mcr.microsoft.com/devcontainers/base:resolute`](https://hub.docker.com/r/microsoft/devcontainers) image, which tracks the current Ubuntu LTS base image. It is configured to run as the non-root user `vscode` by default. File permissions and mounted volumes will be owned and accessed by the `vscode` user (uid = `1000`, gid = `1000`).

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

This approach provides several benefits:

- Ensures that pipelines can validate the Devcontainer setup.
- Allows Dependabot to track updates.
- Makes it easy to extend the image with additional tools as needed.

If you need the Ansible tooling variant, extend the published `-ansible` tag instead:

```Dockerfile
FROM sommerfeldio/devcontainer:latest-ansible
LABEL maintainer="sebastian@sommerfeld.io"
```

## How to Build

Use the repository's canonical `task` workflow to build the published variants locally:

```bash
task build:devcontainer

task build:devcontainer-ansible
```

The underlying Dockerfile exposes explicit `baseline` and `ansible` stages. Equivalent raw Docker commands are:

To build the baseline image locally, run:

```bash
cd components/devcontainer # if from the root of the repository
docker build --target baseline -t local/devcontainer:dev .
```

To build the published Ansible variant from the explicit `ansible` stage locally, run:

```bash
cd components/devcontainer # if from the root of the repository
docker build --target ansible -t local/devcontainer:dev-ansible .
```

## License

This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/license).

The license from this GitHub repository is compatible with the [license from the devcontainers project](https://github.com/devcontainers/images/blob/main/LICENSE) which is MIT as well.
