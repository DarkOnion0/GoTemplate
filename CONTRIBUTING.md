# How to contribute

## Set up your dev env

1. Install [`nix`](https://nixos.org/download.html)
2. Enable [`nix flakes`](https://nixos.wiki/wiki/Flakes)
3. Clone the repo with either git or nix flake (`nix flake clone github:DarkOnion0/GoTemplate --dest [DEST]`)
4. Enter the dev env
   - (RECOMMENDED), install [`direnv`](https://github.com/direnv/direnv) and allow the dir (`direnv allow`)
   - enter the nix dev shell, `nix develop`
5. **✨ Happy coding !**

## Commit formatting

> _💡 NOTE: you can extend the base type provided by the conventional commit by some that comes from any other major repo that support this convention like the [angular repo](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#type)_

Please follow [the conventional commit convention](https://www.conventionalcommits.org/en/v1.0.0/)

The scopes should be set according to:

- The actions names for all the `ci` tag
- The go package name for all the code related tags (`feat`, `fix`...)
- The technology used for every other tags, for example, if the change is on the `justfile` the commit will look like. Also don't hesitate to check out how was formatted the previous commit for the files you edited

  ```text
  build(just): [COMMENT]
  ```
