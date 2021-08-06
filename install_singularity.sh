#!/bin/bash

function install_singularity {
    export SINGULARITY_VERSION=3.7.0 GO_VERSION=1.16.4 OS=linux ARCH=amd64
    cd /tmp
    wget https://dl.google.com/go/go$GO_VERSION.$OS-$ARCH.tar.gz
    sudo tar -C /usr/local -xzvf go$GO_VERSION.$OS-$ARCH.tar.gz
    rm go$GO_VERSION.$OS-$ARCH.tar.gz
    export PATH=/usr/local/go/bin:$PATH
    echo 'export PATH=/usr/local/go/bin:$PATH' >> $BASHRCFILE

    sudo apt install -y build-essential libssl-dev uuid-dev libgpgme11-dev squashfs-tools libseccomp-dev wget pkg-config git cryptsetup
    mkdir -p $HOME/.local/src && cd $HOME/.local/src
    wget https://github.com/hpcng/singularity/releases/download/v${SINGULARITY_VERSION}/singularity-${SINGULARITY_VERSION}.tar.gz 
    tar -xzf singularity-${SINGULARITY_VERSION}.tar.gz
    rm singularity-${SINGULARITY_VERSION}.tar.gz
    cd singularity
    bash mconfig
    make -C builddir
    sudo make -C builddir install
}

install_singularity
