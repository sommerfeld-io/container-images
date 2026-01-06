# sommerfeldio/revealjs

The `sommerfeldio/revealjs` image is a utility Docker image used to render [RevealJS](https://revealjs.com) presentations based on Markdown files and HTML templates.

- [sommerfeldio/revealjs](https://hub.docker.com/r/sommerfeldio/revealjs) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/revealjs) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/CONTRIBUTING.md)
- Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

## Software Tags and Versioning

Learn about our tagging policy and the difference between rolling tags and immutable tags [on our documentation page⁠](https://github.com/sommerfeld-io/.github/blob/main/docs/tags-and-versions.md).

## Usage

RevealJS supports rendering presentations based on Markdown files which we find the most convenient way to create slides.

To serve a presentation based on your own `index.html` and markdown files and monitor source files for changes, you can use the following `docker run` command:

```bash
docker run --rm -it -p 8000:8000 \
    --volume ./index.html:/work/reveal.js/index.html \
    --volume ./slides:/work/reveal.js/slides \
    sommerfeldio/revealjs:latest
```

Alternatively, you can use Docker Compose with the following service definition:

```yaml
services:
  revealjs:
    image: sommerfeldio/revealjs:latest
    ports:
      - 8000:8000
    volumes:
      - ./index.html:/work/reveal.js/index.html
      - ./slides:/work/reveal.js/slides
```

You need to override the default `index.html`. For your Markdown files, the most convenient way is to mount them into the `/work/reveal.js/slides` directory. This way, all resources are available in the container. See the [demo presentation](https://github.com/sommerfeld-io/container-images/tree/main/components/revealjs/demo) for an example.

Simply mounting all files from your (current) directory into `/work/reveal.js` will not work because this would override the default contents of `/work/reveal.js` including the necessary `node_modules` and dependencies. This is also the reason why you cannot change the working directory to another path.

> **NOTE:** RevealJS provides more ways to create presentations, e.g. by using only HTML files. But for us, Markdown is the most convenient way. So we focus on this method and did not put much effort into testing other methods.

## Convert presentation to PDF

This image does not support exporting presentations to PDF yet but we plan to add [the feature](https://github.com/sommerfeld-io/container-images/issues/140) in the future.

## License

This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/license).

The license from this GitHub repository is compatible with the [license from the reveal.js project](https://github.com/hakimel/reveal.js/blob/master/LICENSE) which is MIT as well.
