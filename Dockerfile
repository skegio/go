FROM skegio/base

RUN apt-get update && apt-get install gcc -y
RUN curl -L https://golang.org/dl/go1.17.1.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH $PATH:/usr/local/go/bin

# set up environment
RUN echo "export PATH=\$PATH:/usr/local/go/bin\n" > /etc/profile.d/go.sh
