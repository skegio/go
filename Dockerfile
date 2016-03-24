FROM skegio/base

RUN apt-get install gcc -y
RUN curl https://storage.googleapis.com/golang/go1.4.3.linux-amd64.tar.gz | tar -C /usr/local -xzf -

# Patch for https://github.com/golang/go/issues/13114, obtained from 
# https://raw.githubusercontent.com/NixOS/nixpkgs/ff69fc6fb9093decaaa4a16f89dffce40fc55803/pkgs/development/compilers/go/new-binutils.patch
COPY newbinutils.patch /usr/local/go/newbinutils.patch
RUN cd /usr/local/go && patch -p1 < newbinutils.patch

ENV PATH $PATH:/usr/local/go/bin

# from https://github.com/docker-library/golang/blob/master/1.4/cross/Dockerfile

ENV GOLANG_CROSSPLATFORMS \
    darwin/amd64 \
    linux/amd64 linux/arm \
    windows/amd64
ENV GOARM 5

RUN cd /usr/local/go/src \
    && set -ex \
    && for platform in $GOLANG_CROSSPLATFORMS; do \
        GOOS=${platform%/*} \
        GOARCH=${platform##*/} \
        ./make.bash --no-clean 2>&1; \
    done

# set up environment
RUN echo "export GOPATH=\$HOME/go\nexport PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin\n" > /etc/profile.d/go.sh
