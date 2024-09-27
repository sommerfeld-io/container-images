# sommerfeldio/folderslint

The [sommerfeldio/folderslint](https://hub.docker.com/r/sommerfeldio/folderslint) image is a utility Docker image used in Github Actions workflows to validate the directory structure of a project. The image ships with [folderslint](https://www.npmjs.com/package/folderslint).

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

## License
This container image is inheriting the [License from the GitHub repository](https://sommerfeld-io.github.io/container-images/about/license).