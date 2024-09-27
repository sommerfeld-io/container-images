# Getting started

To get create a new repository based on this template, click the "Use this template" button on the repository page. This will create a new repository with the same structure and files as this repository.

This repository contains the following components:

- A generic [devcontainer](https://code.visualstudio.com/docs/devcontainers/containers) setup based on [Ubuntu](https://hub.docker.com/r/microsoft/devcontainers-base). The devcontainer setup comes with [pre-commit](https://pre-commit.com) installed and configured.
- A template for documentation with Markdown. The documentation site is rendered with [Material for MkDocs](https://squidfunk.github.io/mkdocs-material) and deployed to GitHub Pages. There is no dedicated Dockerfile for the docs site.
- Basic GitHub Actions Workflows with checks for linting and building the documentation site and creating releases. The repository comes with [semantic-release](https://github.com/semantic-release/semantic-release) to create new releases and tags based on the commit messages. This is the only way a release and Git tag should be created. Linter definitions are also included.
- Some more helpful GitHub Actions Workflows for managing issues and pull requests and a basic dependabot configuration.

## Things to do when using this Container Images
- [x] Run `gh repo edit --enable-discussions --enable-issues --enable-projects --enable-wiki=false --visibility=public` to ensure consistent settings across repositories.
- [x] Link the repository to project [sommerfeld.io](https://github.com/orgs/sommerfeld-io/projects/1)
- [x] Search for `Container Images` in all files and replace with the name of the new project. Search for `container-images` as well and replace with the name of the GitHub repository (the part of the URL). Doing so should update the following files:
    - [x] Update volume mounts and workdir in `docker-compose.yml`
    - [x] Update name and description in `package.json`
    - [x] Update site and repository information anf (if needed) the theme/colors and navigation in `mkdocs.yml`
    - [x] Update Docker icon link in `mkdocs.yml` to point to the correct artifact on Docker Hub
- [ ] Update GitHub deployment protection rules in "Settings > Environments" to allow deployments to GitHub pages from tags (add `v*`). It is possible that a the `pipeline.yml` workflow must run (and probably fail) first because this workflow contains a step which enables GitHub Pages for the repository.
  ![protection-rule](_assets/github-pages-environment-protection.png)
- [x] Update documentation in `docs` directory
    - [x] Remove the docs that are intended to explain the Container Images. These are the files in the `docs/usage` directory. Replace them with the real usage documentation.
    - [x] Inspect the `docs/about` directory and update the content to reflect the new project.
- [x] Setup Actions secrets and dependabot secrets in the repository settings
- [ ] Add any additional configuration e.g. for SonarCloud or any other relevant config.
