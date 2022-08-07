{
  description = "A little go app: GoTemplate";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, flake-utils, nixpkgs, nixpkgsUnstable }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (builtins) substring;
        pkgs = nixpkgs.legacyPackages.${system};
        pkgsUnstable = nixpkgsUnstable.legacyPackages.${system};

        # to work with older version of flakes
        lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

        # Generate a user-friendly version number.
        version = builtins.substring 0 8 lastModifiedDate;
      in
      {
        packages = rec {
          default = gotemplate;

          gotemplate = pkgs.buildGoModule {
            pname = "gotemplate";
            inherit version;
            src = ./.;
            vendorSha256 = "sha256-n4uwlf7TI2EtWJWNkkaStKR2lCexjmx/SP2Pc0939II=";
          };
        };

        devShells.default = pkgs.mkShell {
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

          packages = [
            # Go
            pkgs.go_1_17
            pkgs.goreleaser

            # LSP
            pkgs.gopls
            pkgs.rnix-lsp

            # Debugger
            pkgsUnstable.delve

            # Scripting
            pkgs.zip
            pkgs.unzip
            pkgs.gh
            pkgs.git-cliff

            # Command runner
            pkgs.just

            # Linter
            pkgsUnstable.golangci-lint

            # Formater
            pkgs.nodePackages.prettier
            pkgs.nixpkgs-fmt
          ];
        };

        apps = rec {
          default = gotemplate;
          gotemplate = {
            type = "app";
            program = "${self.packages.${system}.default}/bin/GoTemplate";
          };
        };
      });
}
