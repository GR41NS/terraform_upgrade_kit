FROM alpine:3.18

# Basic dependencies
RUN apk add --no-cache \
    bash \
    curl \
    git \
    git-lfs \
    make \
    openssh-client \
    openssl

# Install tfenv
RUN git clone --depth 1 https://github.com/tfutils/tfenv.git ~/.tfenv
RUN ln -s ~/.tfenv/bin/* /usr/local/bin

ARG TF_VERSION 1.6
# Install target TF version
RUN tfenv install ${TF_VERSION}
RUN tfenv use ${TF_VERSION}

USER root

ARG CD
WORKDIR /app/${CD}
ENTRYPOINT [ "/bin/bash" ]
