# sommerfeldio/ftp-client

The `sommerfeldio/ftp-client` image ships with NCFTP and uses [ncftpput](https://www.ncftp.com/ncftp/doc/ncftpput.html) for FTP uploads.

- [sommerfeldio/ftp-client](https://hub.docker.com/r/sommerfeldio/ftp-client) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/ftp-client) on GitHub
- [How to Contribute](https://github.com/sommerfeld-io/.github/blob/main/CONTRIBUTING.md)
- Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

## Software Tags and Versioning

Learn about our tagging policy and the difference between rolling tags and immutable tags [in our documentation page⁠](https://github.com/sommerfeld-io/.github/blob/main/docs/tags-and-versions.md).

## How to use this image

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

## License

This container image is inheriting the [MIT License from the GitHub repository](https://sommerfeld-io.github.io/container-images/license).

The NCFTP software included within the image as a dependency is licensed under [the Clarified Artistic License](https://www.ncftp.com/ncftp/doc/LICENSE.txt).

The Clarified Artistic License is generally considered compatible with the MIT License. Both licenses are permissive open-source licenses, meaning they allow the software to be freely used, modified, and redistributed.

This means:

- MIT License: You are free to use, modify, and distribute this image, provided that you include the original MIT license text and give appropriate attribution to the author(s).
- Clarified Artistic License: The included software under this license remains unmodified. If you modify the included dependency under the Clarified Artistic License, ensure that any changes are clearly distinguished from the original work.
