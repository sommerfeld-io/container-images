# sommerfeldio/shdoc

This image is used to generate Markdown files based on inline documentation comments from source code files. The image uses [shdoc](https://github.com/reconquest/shdoc) to translate comments into Markdown. shdoc is a documentation generator for bash/zsh/sh for generating API documentation in Markdown from shell scripts source.

- [sommerfeldio/shdoc](https://hub.docker.com/r/sommerfeldio/shdoc) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/shdoc) on GitHub
- [How to Contribute](https://sommerfeld-io.github.io/container-images/about/contribute)
- Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

This image is based on [Ubuntu](https://hub.docker.com/_/ubuntu) and ships with shdoc and all its dependencies. For instructions on how to write comments for shdoc, please refer to the [shdoc documentation](https://github.com/reconquest/shdoc).

## Usage
Originally shdoc is designed to work with Bash scripts. However, since Bash scripts use the Hash-sign as a comment character, it is possible to use shdoc with other languages as well. shdoc generates an introduction and docs for every function in the Bash script. But generating header docs seems tot work for all languages, that share the Hash-sign as a comment character. We used it successfully with `Dockerfile`, `Vagrantfile`, `Makefile` and `yaml` files as well.

```yaml
services:

  generate-docs:
    container_name: generate-docs
    image: sommerfeldio/shdoc:latest
    volumes: .:/workspaces/project-name
    working_dir: /workspaces/project-name
    command:
      - /bin/bash
      - -c
      - |
        rm -rf docs/generated
        mkdir -p docs/generated

        shdoc < some/bash-script.sh > docs/generated/bash-script-sh.md
        shdoc < Dockerfile > docs/generated/dockerfile.md

        chown -R 1000:1000 docs/generated
```

This example removes and re-creates the `docs/generated` folder to ensure no Markdown files for deleted files are left. This is not mandatory but recommended to ensure the docs are always up-to-date. The `chown` command is used to ensure the files are owned by the user running the container.

## License
This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/about/license).

The license from this GitHub repository is compatible with the [license from the shdoc project](https://github.com/reconquest/shdoc/blob/master/LICENSE) (which is MIT as well).
