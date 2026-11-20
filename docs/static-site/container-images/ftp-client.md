# sommerfeldio/ftp-client

The `sommerfeldio/ftp-client` image ships with NCFTP and uses [ncftpput](https://www.ncftp.com/ncftp/doc/ncftpput.html) for FTP uploads.

The image is based on the [Docker Hardened Image](https://docs.docker.com/dhi/) `dhi.io/debian-base` (Debian 13 Trixie, `-dev` variant).

- [sommerfeldio/ftp-client](https://hub.docker.com/r/sommerfeldio/ftp-client) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/ftp-client) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/CONTRIBUTING.md)
- [Vulnerability Report](https://sommerfeld-io.github.io/container-images/cve/) with the known vulnerabilities of this image (`edge` and `latest`)

## Software Tags and Versioning

Learn about our tagging policy and the difference between rolling tags and immutable tags [on our documentation page⁠](https://github.com/sommerfeld-io/.github/blob/main/docs/tags-and-versions.md).

## Usage

To use the image run the following command from a bash file.

```bash
FTP_HOST="ftp-host.example.com"
FTP_USER="the_username"
FTP_PASS="the_password"
# CAUTION: Storing credentials in variables like
# this is not a recommended way to handle secrets

docker run -i --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    sommerfeldio/ftp-client:latest ncftpput -R -v -u "$FTP_USER" -p "$FTP_PASS" "$FTP_HOST" / ./*
```

## Software Bill of Materials (SBOM)

Every image comes with a Software Bill of Materials (SBOM) in [SPDX](https://spdx.dev) JSON format, one per platform (`linux/amd64`, `linux/arm64`). The SBOM is created with [syft](https://github.com/anchore/syft) at build time and attached to the image on Docker Hub as an attestation. It is available for `edge`, `latest` and every version tag (starting with `0.25.2`) and always matches the image digest the tag points to.

All you need is Docker with the [buildx plugin](https://github.com/docker/buildx). Pulling the image is not required.

```bash
# Show the SBOM of all platforms
docker buildx imagetools inspect sommerfeldio/ftp-client:latest --format '{{ json .SBOM }}'

# Save the SBOM of one platform as a file
docker buildx imagetools inspect sommerfeldio/ftp-client:latest --format '{{ json (index .SBOM "linux/amd64").SPDX }}' > ftp-client-amd64.spdx.json
```

For a specific version, replace `latest` with the version tag, e.g. `sommerfeldio/ftp-client:0.25.2`. As an alternative, `docker scout sbom sommerfeldio/ftp-client:latest` shows the SBOM as well.

The [Vulnerability Report](https://sommerfeld-io.github.io/container-images/cve/) shows the known vulnerabilities of the `edge` and `latest` tags of all images, based on these SBOMs. It is updated daily.

## Support for the Packaged Software

We publish this image so you can conveniently use the tool or collection of tools inside it. We maintain the image itself, but we do not maintain the packaged tools and do not provide support for the software inside the container. Please report issues with a tool to its upstream project.

## License

This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/license).

The NCFTP software included within the image as a dependency is licensed under [the Clarified Artistic License](https://www.ncftp.com/ncftp/doc/LICENSE.txt).

The Clarified Artistic License is generally considered compatible with the MIT License. Both licenses are permissive open-source licenses, meaning they allow the software to be freely used, modified, and redistributed.

This means:

- MIT License: You are free to use, modify, and distribute this image, provided that you include the original MIT license text and give appropriate attribution to the author(s).
- Clarified Artistic License: The included software under this license remains unmodified. If you modify the included dependency under the Clarified Artistic License, ensure that any changes are clearly distinguished from the original work.
