#!/usr/bin/env just --justfile

# Just SETTINGS (vars...)
set dotenv-load

VERSION := "latest"
PROJECT := "GoTemplate"
BINARY_NAME := "gotemplate"
# Could be amd64, i389, armv6, armv7, armv8
HOST_ARCH := "amd64"
CONTAINER_NAME := "ghcr.io/darkonion0/gotemplate"
CONTAINER_BUILDER := "docker"
export GH_TOKEN := ""
export GH_REPO := env_var_or_default("GH_REPO", "DarkOnion0/{{PROJECT}}")

#Change the default just behaviour
default:
  @just --list

# Build app for all plateform
build: install
    #!/usr/bin/env bash

    if [ {{VERSION}} == "latest" ]; then
        echo "Running in dev mode, VERSION={{VERSION}}"
        goreleaser release --snapshot --rm-dist
    else
        echo "Running in release mode, VERSION={{VERSION}}"
        goreleaser release --snapshot
    fi

# Clean the remote GHCR container registry
#cleanc:
#    @echo -e "\nClean the remote container registry"
#    ./delete_remote_images.sh

# Clean the binary folder
cleanb:
    rm -rf ./bin

# Lint the project files
lint: install
    @echo -e "\nLint all go files"
    golangci-lint run --verbose --fix --timeout 5m .

# Format all the project files
format:
    @echo -e "\nFormat go code"
    gofmt -w .

    @echo -e "\nFormat nix code with nixpkgs-fmt"
    nixpkgs-fmt .

    @echo -e "\nFormat other code with prettier (yaml, md...)"
    prettier -w .

# Check the go.mod and the go.sum files
check: install
    @echo -e "\nVerify dependencies have expected content"
    go mod verify
    
    @echo -e "\nCheck if go.mod and go.sum are up to date"
    go mod tidy

# Run all the checks, linters... of the project
check_full: check format lint

# Generate the git changelog
generate_changelog TYPE="":
    #!/usr/bin/env bash
    
    #@echo -e "\nGenerate the changelog with git-cliff"
    
    if [ {{TYPE}} == "TYPE=ci" ]; then
        git-cliff --verbose --date-order --latest | gh release edit --notes-file - {{VERSION}}
    else
        git-cliff --verbose --date-order -o CHANGELOG.md
    fi

# App dev command, binary mode
dev ARGS: check
    @echo -e "\nRun {{PROJECT}} in dev mode (binary)"
    go run cli/main.go {{ARGS}}

# App dev command, container mode
dev_container: build
    @echo -e "\nRun {{PROJECT}} in dev mode (container)"
    {{CONTAINER_BUILDER}} run -e DEBUG="true" {{CONTAINER_NAME}}:next-{{HOST_ARCH}}

# Run the prerequisites to install all the missing deps that nix can't cover
install:
    @echo -e "\nInstall the go prerequisites"
    go mod download

# Rename all the file in the project containing some User/Repo specific value
rebrand_project:
    #!/usr/bin/env bash

    ##########
    ## VARs ##
    ##########

    OldVar=("DarkOnion0" "darkonion0" "GoTemplate" "gotemplate")

    #########
    ## CMD ##
    #########

    for i in "${!OldVar[@]}"; do
      read -e -p "Input the value to replace '${OldVar[$i]}': " NewVar

      find . -path ./.git -prune -o -type f -exec sed -i -e "s/${OldVar[$i]}/$NewVar/g" {} \;
    done