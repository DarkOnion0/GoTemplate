{
  description = "A little go app: GoTemplate";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs, nixpkgsUnstable }:
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux flake-utils.lib.system.aarch64-linux flake-utils.lib.system.i686-linux ] (system:
      let
        inherit (builtins) substring;

        # to work with older version of flakes
        lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

        # Generate a user-friendly version number.
        version = builtins.substring 0 8 lastModifiedDate;

        # Packages aliases
        pkgs = nixpkgs.legacyPackages.${system};
        pkgsUnstable = nixpkgsUnstable.legacyPackages.${system};

        # Docker image
        # WARNING: these docker image are immutable, if you want to update them you will
        # need to update the attr set with the following command:
        # nix-prefetch-docker --image-name docker.io/library/busybox --image-tag stable-uclibc --arch [DOCKER_ARCH] --os [DOCKER_OS]
        #
        # TODO: automate the update command above
        dockerImage = pkgs.dockerTools.pullImage rec {
          # Linux
          aarch64-linux = {
            imageName = "docker.io/library/busybox";
            imageDigest = "sha256:3040781b979f3560458e64457a60a7ac4f912b6b84dfd3df942df668361200bb";
            sha256 = "1vww852l2j7r0xyhg2kp8xg2hw8ysqdb1ry0mi6iqhkw1g2giyxc";
            finalImageName = "docker.io/library/busybox";
            finalImageTag = "stable-uclibc";
            os = "linux";
            arch = "arm64";
          };
          i686-linux = {
            imageName = "docker.io/library/busybox";
            imageDigest = "sha256:3040781b979f3560458e64457a60a7ac4f912b6b84dfd3df942df668361200bb";
            sha256 = "138zjg38bmiij3gb5b27ha49ki3nx9gyscsznvq51am8s8nfr4q6";
            finalImageName = "docker.io/library/busybox";
            finalImageTag = "stable-uclibc";
            os = "linux";
            arch = "386";
          };
          x86_64-linux = {
            imageName = "docker.io/library/busybox";
            imageDigest = "sha256:3040781b979f3560458e64457a60a7ac4f912b6b84dfd3df942df668361200bb";
            sha256 = "0i71i5fxrcxh986fgzx4lz51m8z2151q0vaqh5i6iw5xwkiacc86";
            finalImageName = "docker.io/library/busybox";
            finalImageTag = "stable-uclibc";
            os = "linux";
            arch = "amd64";
          };
        }.${system};
      in
      rec {
        packages = rec {
          default = gotemplate;

          gotemplate = pkgs.buildGoModule {
            pname = "gotemplate";
            inherit version;

            CGO_ENABLED = 0;

            src = ./.;

            vendorSha256 = "sha256-n4uwlf7TI2EtWJWNkkaStKR2lCexjmx/SP2Pc0939II=";
          };

          #############
          ## WARNING ##
          #############

          # You need to keep this file in sync with the docker image inside `Dockerfile` if you are using
          # nix and goreleaser at the same time to build the docker image

          docker = pkgs.dockerTools.buildLayeredImage {
            name = default.pname;
            tag = default.version;
            contents = [ default ];

            created = "now";

            fromImage = dockerImage;

            config = {
              Env = [
                "DEBUG=false"
              ];

              WorkingDir = "/";

              Cmd = [ "sh" "-c" "/bin/GoTemplate -debug $DEBUG" ];
            };
          };
        };

        devShells = {
          default = pkgs.mkShell {
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
              pkgs.nix-prefetch-docker # to generate the nix pullImage function attr set

              # Command runner
              pkgs.just

              # Linter
              pkgsUnstable.golangci-lint

              # Formater
              pkgs.nodePackages.prettier
              pkgs.nixpkgs-fmt
            ];
          };
        };

        apps = rec {
          default = gotemplate;
          gotemplate = {
            type = "app";
            program = "${self.packages.${system}.default}/bin/GoTemplate";
          };
        };
      }
    );
}
