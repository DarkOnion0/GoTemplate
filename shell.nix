{ pkgs ? import <nixpkgs> { }
}:
pkgs.mkShell {
  shellHook = ''
    # Go command
    go mod verify
    go mod tidy
    go mod download

    # Welcome script
    echo -e "\n$(tput bold)Welcome in the nix-shell for GoTemplate$(tput sgr0)"
      
    echo -e "\nList of custom command using 'just' a 'GNU make' like software :"
    echo -e "================================================================"
    just -l
    echo -e "================================================================"
  '';

  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = with pkgs; [
    # Go
    go_1_17
    goreleaser

    # LSP
    gopls
    rnix-lsp

    # Debugger
    delve

    # Scripting
    zip
    unzip
    gh
    git-cliff

    # Command runner
    just

    # Linter
    golangci-lint

    # Formater
    nodePackages.prettier
    nixpkgs-fmt
  ];
}
