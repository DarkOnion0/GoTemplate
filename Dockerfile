#############
## WARNING ##
#############

# You need to keep this file in sync with docker image inside `flake.nix` if you are using goreleaser
# and nix at the same time to build the docker image

FROM docker.io/library/busybox:stable-uclibc

WORKDIR /src/app

# Copy the executable build i nthe previous step
COPY gotemplate .

# Env variables
ENV DEBUG "false"

CMD ./gotemplate -debug $DEBUG
