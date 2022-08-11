# GoTemplate

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org) [![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-Ready--to--Code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/DarkOnion0/GoTemplate) [![Build](https://github.com/DarkOnion0/GoTemplate/actions/workflows/build.yml/badge.svg)](https://github.com/DarkOnion0/GoTemplate/actions/workflows/build.yml) [![Check code](https://github.com/DarkOnion0/GoTemplate/actions/workflows/check.yml/badge.svg)](https://github.com/DarkOnion0/GoTemplate/actions/workflows/check.yml) [![Publish Changelog](https://github.com/DarkOnion0/GoTemplate/actions/workflows/changelog.yml/badge.svg)](https://github.com/DarkOnion0/GoTemplate/actions/workflows/changelog.yml) [![Latest release](https://shields.io/github/v/release/DarkOnion0/GoTemplate?display_name=tag&include_prereleases&label=%F0%9F%93%A6%20Latest%20release)](https://shields.io/github/v/release/DarkOnion0/GoTemplate?display_name=tag&include_prereleases&label=%F0%9F%93%A6%20Latest%20release)

## 🚀 Main Features

## 📖 Usage

### 📦️ Providers

<details>
  <summary>
    Docker (recommended)
  </summary>
  <p>
  
  1. Download the container from GitHub
  2. Run it, further configuration can be done, see the corresponding sections below.

    docker pull ghcr.io/darkonion0/gotemplate:latest
    docker run ghcr.io/darkonion0/gotemplate:latest

  </p>
</details>

<details>
  <summary>
    Nix flake (recommended)
  </summary>
  <p>
  
  1. Install [`nix`](https://nixos.org/download.html)
  2. Enable [`nix flakes`](https://nixos.wiki/wiki/Flakes)
  3. Run the app, further configuration can be done, see the corresponding sections below. You can set an optional version tag / branch or just leave it as is to follow the main branch

    ```bash
    ❯ nix run github:DarkOnion0/GoTemplate/[GIT_VERSION_TAG]#default -- [ARGs]
    ```

  </p>
</details>

<details>
  <summary>
    Binary
  </summary>
  <p>
  
  1. Download the binary from the release page
  2. Run it, further configuration can be done, see the corresponding sections below.

    ```bash
    ❯ ./gotemplate [ARGs]
    ```

  </p>
</details>

### 🧰 Configuration

Here is the list of all the cmd flags available, they can be used by transposing them in capitalized [snake case](https://en.wikipedia.org/wiki/Letter_case#Snake_case) for the docker env settings (Ex: `-debug-enable` will become `DEBUG_ENABLE`) or by transposing them to [camel case](https://en.wikipedia.org/wiki/Camel_case) for the nix module settings (Ex: `-debug-enable` will become `debugEnable`, it doesn't exist yet 😅)

```text
Usage of /nix/store/596fiqgpjiqq3i927d15vxwwap7gi3n9-gotemplate-20220811/bin/GoTemplate:
  -debug string
        Sets log level to debug (default "false")
```

## 🫶 Contributing

Your contribution is welcome and really appreciated, please see [`CONTRIBUTING.md`](https://github.com/DarkOnion0/GoTemplate/blob/main/CONTRIBUTING.md)
