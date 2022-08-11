# GoTemplate

> _This template aims to make a full featured go boilerplate with nix at its core_

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-Ready--to--Code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/DarkOnion0/GoTemplate) [![Build](https://github.com/DarkOnion0/GoTemplate/actions/workflows/build.yml/badge.svg)](https://github.com/DarkOnion0/GoTemplate/actions/workflows/build.yml) [![Check code](https://github.com/DarkOnion0/GoTemplate/actions/workflows/check.yml/badge.svg)](https://github.com/DarkOnion0/GoTemplate/actions/workflows/check.yml) [![Publish Changelog](https://github.com/DarkOnion0/GoTemplate/actions/workflows/changelog.yml/badge.svg)](https://github.com/DarkOnion0/GoTemplate/actions/workflows/changelog.yml) [![Latest release](https://shields.io/github/v/release/DarkOnion0/GoTemplate?display_name=tag&include_prereleases&label=%F0%9F%93%A6%20Latest%20release)](https://shields.io/github/v/release/DarkOnion0/GoTemplate?display_name=tag&include_prereleases&label=%F0%9F%93%A6%20Latest%20release)

## 🚀 Main Features

- Ultra light `docker` images with a kind of multi-stage docker image
- A `just` file (a modern and more convenient make replacement) with full-featured recipes
- GitHub Action with linting, formatting, building, releasing...
- Reproducible dev environment with `nix flakes` and `gitpod`
- Full-featured build system with `nix flakes` and `goreleaser`

## 📖 Usage

Hi dear user, this repo need some tweaking after cloning it right from the template

1. You need to create a secret `COMMIT_TOKEN` with the `workflow` and `repo` scopes to allow auto-formatting the code with GitHub actions
2. You need to run the `rebrand_project` just recipe, to update all the user / repo specific refs
   ```sh
   just rebrand_project
   ```
3. (OPTIONAL), you can also change the description of the `nix flake` and add the corresponding configs if your app need them
4. (OPTIONAL), delete / edit the `CONTRIBUTING.md` file

## 🫶 Contributing

Your contribution is welcome and really appreciated, please see [`CONTRIBUTING.md`](https://github.com/DarkOnion0/GoTemplate/blob/main/CONTRIBUTING.md)
