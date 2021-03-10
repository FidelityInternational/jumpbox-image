FROM ubuntu:focal
ENV DEBIAN_FRONTEND "noninteractive"
ENV ENV TZ=Europe/London
ENV PACKAGES "zlib1g-dev libssl-dev file awscli unzip curl openssl ca-certificates git jq util-linux gzip bash uuid-runtime coreutils vim tzdata openssh-client gnupg make zip golang rubygems rubygems-integration pwgen python3-pip tree dnsutils build-essential ruby-dev python3-dev libkrb5-dev libmagic-dev tmux iputils-ping"
RUN printf "Acquire {\n  HTTP::proxy \"%s\"/;\n  HTTPS::proxy \"%s\"/;\n}\n" ${http_proxy} ${http_proxy} > /etc/apt/apt.conf.d/proxy.conf
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends ${PACKAGES} && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip
ENV BOSH_VERSION "6.4.0"
ENV SPRUCE_VERION "1.27.0"
ENV CF_CLI_VERSION "6.52.0"
ENV YQ_VERSION "3.2.1"
ENV GOVC_VERSION "0.23.0"
ENV CREDHUB_VERSION "2.8.0"
ENV TERRAFORM_VERSION "0.13.5"
RUN curl -fL "https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${CREDHUB_VERSION}/credhub-linux-${CREDHUB_VERSION}.tgz" | tar -zx -C /usr/local/bin
RUN curl -fL "https://s3-us-west-1.amazonaws.com/cf-cli-releases/releases/v${CF_CLI_VERSION}/cf-cli_${CF_CLI_VERSION}_linux_x86-64.tgz" | tar -zx -C /usr/local/bin
RUN curl -fL "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq
RUN curl -fL "https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERION}/spruce-linux-amd64" -o /usr/local/bin/spruce
RUN curl -fL "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-amd64" -o /usr/local/bin/bosh
RUN curl -fL "https://github.com/vmware/govmomi/releases/download/v${GOVC_VERSION}/govc_linux_amd64.gz" | gunzip > /usr/local/bin/govc
RUN curl -fL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" | zcat > /usr/local/bin/terraform
RUN curl -fL "https://raw.githubusercontent.com/FidelityInternational/fly_wrapper/master/fly" -o /usr/local/bin/fly
RUN chmod +x /usr/local/bin/*
RUN mkdir /root/workspace
ENV GOPATH '/root/workspace/'
RUN gem install bundler -v 1.17.3
RUN pip install aws-adfs PyJWT pyyaml requests bs4 ruamel.yaml regex
