#!/usr/bin/env just --justfile

# Just SETTINGS (vars...)
set dotenv-load

VERSION := "latest"
PROJECT := "GoTemaplte"
BINARY_NAME := "gotemplate"
CONTAINER_NAME := "{{BINARY_NAME}}-dev"
CONTAINER_BUILDER := "docker"
export GH_TOKEN := ""
export GH_REPO := env_var_or_default("GH_REPO", "DarkOnion0/{{PROJECT}}")

#Change the default just behaviour
default:
  @just --list

# Build app for all plateform
build: install
    #!/usr/bin/env bash
    @echo -e "\nBuild the app binary for Linux, Mac and Windows"


    #######################################
    ## Global variables and string style ##
    #######################################

    bold=$(tput bold)

    red="\033[0;31m"
    stop_color='\033[0m'

    binaryName={{BINARY_NAME}}

    ##########################################
    ## Set the execution mode of the script ##
    ##########################################

    if [ {{VERSION}} == "latest" ]; then
        VERSION="latest"
        echo "Running in dev mode, version=$VERSION"
    else
        VERSION=$(echo {{VERSION}} | sed -e 's/\./-/g')
        echo "Running in release mode, version=$VERSION"
    fi

    #############################################
    ## Cross-compile the app && ZIP the output ##
    #############################################

    mkdir "bin"
    cd ./bin/

    if [ $VERSION == "single-binary" ]; then
        echo -e "\n$red${bold}Building binary for the container...${bold}$stop_color"

        env CGO_ENABLED=0 go build -o $binaryName-dev ../main.go
    else 

        for os in linux
        do
            # Linux is seperated from the other os due to the fact that it support more architechture
            echo -e "\n$red${bold}Building linux binary...${bold}$stop_color"
            echo -e "$red${bold}===========================${bold}$stop_color"

            for arch in amd64 386 arm64 arm
            do
                echo "${bold}$os/$arch...${bold}"
                env CGO_ENABLED=0 GOOS=$os GOARCH=$arch go build -o $binaryName-$os-$arch-$VERSION ../main.go
                sha256sum $binaryName-$os-$arch-$VERSION > $binaryName-$os-$arch-$VERSION-sha256sum.txt
                zip $binaryName-$os-$arch-$VERSION $binaryName-$os-$arch-$VERSION $binaryName-$os-$arch-$VERSION-sha256sum.txt
            done
        done
    fi

# Build app's container image
build_container: format lint
    @echo -e "\nBuild the app container for a single arch"
    {{CONTAINER_BUILDER}} build . -t {{CONTAINER_NAME}}

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
generate_changelog TYPE="latest":
    #!/usr/bin/env bash
    
    #@echo -e "\nGenerate the changelog with git-cliff"
    
    if [ {{TYPE}} == "latest" ]; then
        git-cliff --verbose --date-order --unreleased --prepend CHANGELOG.md
    elif [ {{TYPE}} == "release" ]; then
        git-cliff --verbose --date-order --latest --prepend CHANGELOG.md
    elif [ {{TYPE}} == "ci" ]; then
        git-cliff --verbose --date-order --latest | gh release edit --note-file - {{VERSION}}
    else
        echo -e "The statement {{TYPE}} is not supported, select either: latest, release or ci"
    fi

# App dev command, binary mode
dev ARGS: check
    @echo -e "\nRun {{PROJECT}} in dev mode (binary)"
    go run cli/main.go {{ARGS}}

# App dev command, container mode
dev_container: build_container
    @echo -e "\nRun {{PROJECT}} in dev mode (container)"
    {{CONTAINER_BUILDER}} run -e DEBUG="true" {{CONTAINER_NAME}}:latest

# Run the prerequisites to install all the missing deps that nix can't cover
install:
    @echo -e "\nInstall the go prerequisites"
    go mod download
