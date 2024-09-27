# sommerfeldio/ftp-client

The [sommerfeldio/ftp-client](https://hub.docker.com/r/sommerfeldio/ftp-client) image ships with NCFTP and uses [ncftpput](https://www.ncftp.com/ncftp/doc/ncftpput.html) for FTP uploads.

- [sommerfeldio/ftp-client](https://hub.docker.com/r/sommerfeldio/ftp-client) on Docker Hub
- [Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/ftp-client) on GitHub
- [How to Contribute](https://sommerfeld-io.github.io/container-images/about/contribute)
- Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

## How to use this image
To use the image run the following command from a bash file.

```bash
FTP_HOST="ftp-host.example.com"
FTP_USER="the_username"
FTP_PASS="the_password" # Storing passwords in variables like this is not a recommended way to handle secrets

echo "Upload via FTP"
docker run -i --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    sommerfeldio/ftp-client:latest ncftpput -R -v -u "$FTP_USER" -p "$FTP_PASS" "$FTP_HOST" / ./*
```

## License
This container image is inheriting the [License from the GitHub repository](https://sommerfeld-io.github.io/container-images/about/license).
