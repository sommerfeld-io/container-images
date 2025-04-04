# sommerfeldio/devcontainer

The `sommerfeldio/devcontainer` Docker image serves as a foundational development environment for projects under the [sommerfeld.io](https://github.com/sommerfeld-io) organization. It includes essential tools required by all repositories. It can be used as either a ready-to-use development container for immediate coding. or as a baseline image that can be extended with additional tools as needed.

- [sommerfeldio/devcontainer](https://hub.docker.com/r/sommerfeldio/devcontainer) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/devcontainer) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/docs/contribute.md)
- Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

## Usage

The easiest way to use this image is by adding a Dockerfile to your repository's `.devcontainer` folder and extending `sommerfeldio/devcontainer`. This approach provides several benefits:

- Ensures that pipelines can validate the Devcontainer setup.
- Allows Dependabot to track updates.
- Makes it easy to extend the image with additional tools as needed.
