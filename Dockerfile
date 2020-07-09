FROM ubuntu:focal
ENV DEBIAN_FRONTEND "noninteractive"
ENV ENV TZ=Europe/London
ENV PACKAGES "zlib1g-dev libssl-dev file awscli unzip curl openssl ca-certificates git jq util-linux gzip bash uuid-runtime coreutils vim tzdata openssh-client gnupg make zip golang rubygems rubygems-integration pwgen python3-pip tree dnsutils build-essential ruby-dev"
RUN printf "Acquire {\n  HTTP::proxy \"%s\"/;\n  HTTPS::proxy \"%s\"/;\n}\n" ${http_proxy} ${http_proxy} > /etc/apt/apt.conf.d/proxy.conf
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends ${PACKAGES} && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip
ENV BOSH_VERSION "6.2.1"
ENV SPRUCE_VERION "1.25.3"
ENV CF_CLI_VERSION "6.51.0"
ENV YQ_VERSION "3.2.1"
ENV GOVC_VERSION "0.22.1"
ENV CREDHUB_VERSION "2.7.0"
RUN curl -fL "https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${CREDHUB_VERSION}/credhub-linux-${CREDHUB_VERSION}.tgz" | tar -zx -C /usr/local/bin && \
    curl -fL "https://s3-us-west-1.amazonaws.com/cf-cli-releases/releases/v${CF_CLI_VERSION}/cf-cli_${CF_CLI_VERSION}_linux_x86-64.tgz" | tar -zx -C /usr/local/bin && \
    curl -fL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    curl -fL "https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERION}/spruce-linux-amd64" -o /usr/local/bin/spruce && \
    curl -fL "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-amd64" -o /usr/local/bin/bosh && \
    curl -fL "https://github.com/vmware/govmomi/releases/download/v${GOVC_VERSION}/govc_linux_amd64.gz" | gunzip > /usr/local/bin/govc && \
    chmod +x /usr/local/bin/*
RUN mkdir ~/dev/
ENV GOPATH '/root/dev/'
RUN gem install bundler -v 1.17.3
