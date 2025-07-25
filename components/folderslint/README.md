# sommerfeldio/folderslint

The `sommerfeldio/folderslint` image is a utility Docker image used in Github Actions workflows to validate the directory structure of a project. The image ships with [folderslint](https://www.npmjs.com/package/folderslint).

- [sommerfeldio/folderslint](https://hub.docker.com/r/sommerfeldio/folderslint) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/folderslint) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/CONTRIBUTING.md)
- Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

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

## License

This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/license).

The license from this GitHub repository is compatible with the [license from the folderslint project](https://github.com/denisraslov/folderslint/blob/master/LICENSE) which is MIT as well.
