FROM ubuntu:focal
ENV DEBIAN_FRONTEND "noninteractive"
ENV ENV TZ=Europe/London
ENV PACKAGES "zlibc ruby libxslt1-dev libxml2-dev libreadline8 libreadline-dev libyaml-dev libsqlite3-dev sqlite3 zlib1g-dev libssl-dev file unzip curl openssl ca-certificates git jq util-linux gzip bash uuid-runtime coreutils vim tzdata openssh-client gnupg make zip golang rubygems rubygems-integration pwgen python3-pip tree dnsutils build-essential ruby-dev python3-dev libkrb5-dev libmagic-dev tmux iputils-ping bash-completion bsdmainutils wget"
RUN printf "Acquire {\n  HTTP::proxy \"%s\"/;\n  HTTPS::proxy \"%s\"/;\n}\n" ${http_proxy} ${http_proxy} > /etc/apt/apt.conf.d/proxy.conf
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends ${PACKAGES} && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/python3 /usr/bin/python
ENV BOSH_VERSION "7.0.1"
ENV SPRUCE_VERION "1.27.0"
ENV CF_CLI_VERSION "7.5.0"
ENV YQ4_VERSION "4.9.6"
ENV GOVC_VERSION "0.28.0"
ENV CREDHUB_VERSION "2.9.3"
ENV TERRAFORM_VERSION "1.2.3"
ENV YTT_VERSION "0.32.0"
ENV AWS_NUKE_VERSION="2.19.0"
RUN curl -fL "https://github.com/rebuy-de/aws-nuke/releases/download/v${AWS_NUKE_VERSION}/aws-nuke-v${AWS_NUKE_VERSION}-linux-amd64.tar.gz" | tar -xz --transform=s/-v"${AWS_NUKE_VERSION}"-linux-amd64// -C /usr/local/bin
RUN curl -fL "https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${CREDHUB_VERSION}/credhub-linux-${CREDHUB_VERSION}.tgz" | tar -zx -C /usr/local/bin
RUN curl -fL "https://s3-us-west-1.amazonaws.com/v7-cf-cli-releases/releases/v${CF_CLI_VERSION}/cf7-cli_${CF_CLI_VERSION}_linux_x86-64.tgz" | tar -zx -C /usr/local/bin
RUN curl -fL "https://github.com/mikefarah/yq/releases/download/v${YQ4_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq
RUN curl -fL "https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERION}/spruce-linux-amd64" -o /usr/local/bin/spruce
RUN curl -fL "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-amd64" -o /usr/local/bin/bosh
RUN curl -fL "https://github.com/vmware/govmomi/releases/download/v${GOVC_VERSION}/govc_linux_amd64.gz" | gunzip > /usr/local/bin/govc
RUN curl -fL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" | zcat > /usr/local/bin/terraform
RUN curl -fL "https://raw.githubusercontent.com/FidelityInternational/fly_wrapper/master/fly" -o /usr/local/bin/fly
RUN curl -fL "https://github.com/vmware-tanzu/carvel-ytt/releases/download/v${YTT_VERSION}/ytt-linux-amd64" -o /usr/local/bin/ytt
RUN curl -fL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl

RUN chmod +x /usr/local/bin/*
RUN mkdir /root/workspace
ENV GOPATH '/root/workspace/'
RUN gem install bundler -v 1.17.3
RUN pip install --no-cache-dir aws-adfs PyJWT pyyaml requests bs4 ruamel.yaml regex awscli xmltodict "ruyaml>=0.20.0" "sure>=1.4.0" \
  "ruyaml>=0.20.0" "git+https://github.com/FidelityInternational/nsxramlclient.git@master" "mamba>=0.8.6" "pyvmomi>=6.0.0.2016.6" "lxml>=4.3.3" \
  iso8601 pytz "git+https://github.com/FidelityInternational/pyraml-parser.git@master" "passlib==1.7.0" "pytest >= 6.0.1" "pytest-mock >= 3.3.0" \
  "pytest-cov >= 2.10.1" "s3cmd >= 2.1.0" "python-magic >= 0.4.18"
