# devcontainer-base

This repository holds the base docker image used to build development containers for Visual Studio Code

## Features

This image is quite similar to [the one created by Quentin](https://github.com/qdm12/basedevcontainer). The main differences are:

- Uses vim as the editor instead of nano
- Uses `avit` oh-my-zsh theme instead of Powerlevel10k theme
- Adds git-extras to the plugins initialized by oh-my-zsh
- Uses [starship](https://starship.rs/) prompt

# TODO

- [ ] Debian based images

# Credits
All the heavy lifting was made by [Quentin McGaw](https://github.com/qdm12/) the base container available here only has minor tweaks to the [base image created by Quentin](https://github.com/qdm12/basedevcontainer).

## License

This repository is under an [MIT license](https://github.com/pap/devcontainer-base/master/LICENSE) unless indicated otherwise.
