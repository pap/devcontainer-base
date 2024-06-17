# devcontainer-base

This repository holds the base docker image used to build development containers for Visual Studio Code

## Features

This image is quite similar to [the one created by Quentin McGaw](https://github.com/qdm12/basedevcontainer). The main differences are:

- Uses vim as the editor instead of nano
- Uses `avit` oh-my-zsh theme instead of Powerlevel10k theme
- Adds git-extras to the plugins initialized by oh-my-zsh
- Uses [starship](https://starship.rs/) prompt

## Building the base image

The Dockerfile makes extensive use of [build arguments](https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables---build-arg) most of them with default values set in the Dockerfile. The only build argument that doesn't have default values is `VERSION`.

To build the image clone this repository and then issue the following command:

```sh
docker build \
  --build-arg VERSION=`date -u +"%Y%m%d"`-`git rev-parse --short HEAD` \
  -t <IMAGE _NAME>:<IMAGE_TAG> .
```

> Note: Replace _IMAGE_NAME_ and _IMAGE_TAG_ with values that make sense for your use case.
In the example above the VERSION is set by concatenating current date with the git revision. Feel free to use any other value that makes sense for you.

## Customizing build via build arguments

This is a list of the build arguments used and their default values:

| Build Argument | default value |
| -------------- | ------------- |
| ALPINE_VERSION | 3.19 |
| USERNAME | vscode |
| USER_UID | 1000 |
| USER_GID | 1000 |
| VERSION | |

> Note: It is not recommended to change most of these default values as a multi stage build is used and you may run into issues such as unexistent docker images depending on the version numbers you set.

The default user for the generated image is `vscode`. Let's say you want the generated image to have a different user. Use the same command as listed above to build the docker image but pass an additional build argument, `USERNAME`:

```sh
docker build \
  --build-arg VERSION=`date -u +"%Y%m%d"`-`git rev-parse --short HEAD` \
  --build-arg USERNAME=demo \
  --platform <PLATFORM> \
  -t <IMAGE NAME>:<IMAGE TAG> .
```

The generated image will run under the `demo` user instead of the default `vscode` one.

## Running a container using the generated image

To run a container using the generated docker image the following command can be used:

```sh
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -e TZ=<TIMEZONE> <IMAGE_ID>
```

`-e TZ="Europe/Madrid"` will set the timezone to Madrid

This command will run in interactive mode and remove the container we exit it. We are also mounting a volume that allows us to connect the container to the host docker socket.

## TODO

- [ ] Debian based images

# Credits

All the heavy lifting was made by [Quentin McGaw](https://github.com/qdm12/) the base container available here only has minor tweaks to the [base image created by Quentin](https://github.com/qdm12/basedevcontainer).

## License

This repository is under an [MIT license](https://github.com/pap/devcontainer-base/master/LICENSE) unless indicated otherwise.
