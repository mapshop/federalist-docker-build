# Docker Builder for federalist

This is a Docker image that runs Jekyll to build a and uploads it to AWS S3. It's used to allow Jekyll sites to build with user-provided plugins in a safe space.

First, the container checks out the site from GitHub. Then it builds the site with Jekyll. Then it gzip compresses text files and sets cache control headers. Finally, it uploads the built site to S3 also creates redirect objects for directories, such as `/path` => `/path/`.

Any errors or final status codes are `POST`ed to a URL.

Configure the build process with following environment variables:

- `AWS_ACCESS_KEY_ID` AWS access key
- `AWS_DEFAULT_REGION` AWS region
- `AWS_SECRET_ACCESS_KEY` AWS secret key
- `CALLBACK` a URL that will receive a `POST` request with a JSON body including the `status` code and output `message` from the Jekyll process
- `BUCKET` S3 bucket to upload the built site
- `BASEURL` `baseurl` value to build the site with, including a leading slash
- `CACHE_CONTROL` Value to set for the Cache-Control header
- `BRANCH` Branch to check out
- `CONFIG` A yaml block of configuration to add to `_config.yml` before building
- `REPOSITORY` Name of the re
- `OWNER` Owner (GitHub user) of the repository
- `PREFIX` Prefix for assets on S3
- `GITHUB_TOKEN` GitHub oauth token for cloning the repository
- `GENERATOR` The static generator to use to build the site (`jekyll` or `hugo`\*; anything else will just publish all files in the repository)

\* The Hugo application is not yet part of this image

The AWS and GitHub token variables are unset in the Jekyll subprocess so Jekyll and its plugins do not have access to this information.

### Development & making changes

You'll need to have `docker` on your machine installed. If you just want to install the container image and run it, you can use `docker pull 18fgsa/federalist-docker-build`. `docker pull` behaves similarly to `git pull`. Run the container with `docker run 18fgsa/federalist-docker-build`.

If you want to make changes, you should first clone the repo and then build the docker container locally.

0. `git clone git@github.com:18F/federalist-docker-build.git && cd federalist-docker-build`
0. `docker build -t federalist-docker-build .`
0. `docker run federalist-docker-build`

After you make any changes to the container, you should run the `docker build` command again before `docker run`.

In either case you'll want to supply your docker container with environment variables. `docker run` accepts an `-e` flag to designate environment variables. You must precede each key/value pair with the flag. For example:
`docker run -e OWNER=18f -e REPOSITORY=18f.gsa.gov federalist-docker-build` (if you used `docker pull` this container image is probably named `18fgsa/federalist-docker-build`).

### Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
