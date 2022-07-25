FROM docker.io/library/alpine:latest

WORKDIR /src/app

# Copy the executable build i nthe previous step
COPY gotemplate .

# Env variables
ENV DEBUG "false"

CMD ./gotemplate -debug $DEBUG
