# sommerfeldio/folderslint

The `sommerfeldio/folderslint` image is a utility Docker image used in Github Actions workflows to validate the directory structure of a project. The image ships with the node module `folderslint`.

The image is based on the [Docker Hardened Image](https://docs.docker.com/dhi/) `dhi.io/node`. The final image contains only the Node.js runtime and `folderslint`, ships without a shell or package manager, and runs as a non-root user (UID `1000`). Make sure the mounted directory is readable for that user.

- [sommerfeldio/folderslint](https://hub.docker.com/r/sommerfeldio/folderslint) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/folderslint) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/CONTRIBUTING.md)
- [Vulnerability Report](https://sommerfeld-io.github.io/container-images/cve/) with the known vulnerabilities of this image (`edge` and `latest`)

## Software Tags and Versioning

Learn about our tagging policy and the difference between rolling tags and immutable tags [on our documentation page⁠](https://github.com/sommerfeld-io/.github/blob/main/docs/tags-and-versions.md).

## Usage

To use the image run the following command.

```bash
docker run -it --rm --volume "$(pwd):$(pwd)" --workdir "$(pwd)" sommerfeldio/folderslint:latest
```

To use in a Github Actions workflow, use the following snippet.

```yaml
lint-folders:
  runs-on: ubuntu-latest
  steps:
    - name: Checkout code
      uses: actions/checkout@v3
    - name: Run folderslint in container
      run: docker run -i --rm --volume "$(pwd):$(pwd)" --workdir "$(pwd)" sommerfeldio/folderslint:latest
```

The image expects a `.folderslintrc` file inside `--workdir` (which typically is the project-root). The file can be used to configure the rules for the directory structure validation in JSON.

```json
{
 "rules": [
  ".devcontainer",
  ".github/workflows",
  ".vscode",

  "app",
  "app/folder",
  "app/folder/sub-folder",
  "app/folder/sub-folder/**",

  "docs/**",

  "node_modules/**",
  "target/**"
 ]
}
```

## Software Bill of Materials (SBOM)

Every image comes with a Software Bill of Materials (SBOM) in [SPDX](https://spdx.dev) JSON format, one per platform (`linux/amd64`, `linux/arm64`). The SBOM is created with [syft](https://github.com/anchore/syft) at build time and attached to the image on Docker Hub as an attestation. It is available for `edge`, `latest` and every version tag (starting with `0.25.2`) and always matches the image digest the tag points to.

All you need is Docker with the [buildx plugin](https://github.com/docker/buildx). Pulling the image is not required.

```bash
# Show the SBOM of all platforms
docker buildx imagetools inspect sommerfeldio/folderslint:latest --format '{{ json .SBOM }}'

# Save the SBOM of one platform as a file
docker buildx imagetools inspect sommerfeldio/folderslint:latest --format '{{ json (index .SBOM "linux/amd64").SPDX }}' > folderslint-amd64.spdx.json
```

For a specific version, replace `latest` with the version tag, e.g. `sommerfeldio/folderslint:0.25.2`. As an alternative, `docker scout sbom sommerfeldio/folderslint:latest` shows the SBOM as well.

The [Vulnerability Report](https://sommerfeld-io.github.io/container-images/cve/) shows the known vulnerabilities of the `edge` and `latest` tags of all images, based on these SBOMs. It is updated daily.

## Support for the Packaged Software

We publish this image so you can conveniently use the tool or collection of tools inside it. We maintain the image itself, but we do not maintain the packaged tools and do not provide support for the software inside the container. Please report issues with a tool to its upstream project.

## License

This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/license).

The license from this GitHub repository is compatible with the [license from the folderslint project](https://github.com/denisraslov/folderslint/blob/master/LICENSE) which is MIT as well.
