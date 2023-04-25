FROM ubuntu:focal

SHELL ["/bin/bash", "-ec"]

ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ=Europe/London

RUN printf "Acquire {\n  HTTP::proxy \"%s\"/;\n  HTTPS::proxy \"%s\"/;\n}\n" ${http_proxy} ${http_proxy} > /etc/apt/apt.conf.d/proxy.conf

RUN apt update && apt upgrade -y && apt install -y --no-install-recommends \
  bash \
  bash-completion \
  bsdmainutils \
  build-essential \
  ca-certificates \
  coreutils \
  curl \
  dnsutils \
  file \
  git \
  gnupg \
  gzip \
  iputils-ping \
  jq \
  libffi-dev \
  libkrb5-dev \
  libmagic-dev \
  libreadline-dev \
  libreadline8 \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  libyaml-dev \
  make \
  netcat \
  openssh-client \
  openssl \
  postgresql-client \
  pwgen \
  rsync \
  software-properties-common \
  sqlite3 \
  tmux \
  tree \
  tzdata \
  unzip \
  util-linux \
  uuid-runtime \
  vim \
  wget \
  zip \
  zlib1g-dev \
  zlibc \
  lsb-release \
  libarchive-tools \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Languages
# GOLANG
ENV GOLANG_VERSION="1.20"
ENV GOPATH='/root/workspace/'
ENV PATH="/usr/lib/go-${GOLANG_VERSION}/bin:${GOPATH}/bin:${PATH}"
RUN add-apt-repository ppa:longsleep/golang-backports \
  && apt update \
  && apt install -y golang-${GOLANG_VERSION} \
  && apt clean && rm -rf /var/lib/apt/lists/*

# RUBY
ENV RUBY_VERSION="3.1.2" \
  BUNDLER_VERSION="2.3.21" \
  PATH="/root/.rbenv/plugins/ruby-build/bin:/root/.rbenv/bin:/root/.rbenv/shims:${PATH}"
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
  && echo 'eval "$(rbenv init -)"' >> ~/.bashrc \
  && git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build \
  && rbenv install ${RUBY_VERSION} \
  && rbenv global ${RUBY_VERSION} \
  && gem install bundler -v ${BUNDLER_VERSION}

# PYTHON
ENV PYTHON_VERSION="3.9.12" \
  PYENV_ROOT="/root/.pyenv" \
  PATH="/root/.pyenv/bin:/root/.pyenv/shims:${PATH}"
RUN git clone https://github.com/pyenv/pyenv.git /root/.pyenv \
  && echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
  && pyenv install ${PYTHON_VERSION} \
  && pyenv global ${PYTHON_VERSION}

# NODE
ENV NODE_VERSION="16.18.1" \
  PATH="/usr/local/node/bin:${PATH}"
RUN mkdir /usr/local/node && curl -fL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" | tar -xJf - --strip-components=1 -C /usr/local/node

# Docker (cli only)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -  \
  && add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  && apt update \
  && apt install -y docker-ce-cli \
  && apt clean && rm -rf /var/lib/apt/lists/*

# Other CLI tools
ENV BOSH_VERSION="7.0.1" \
  SPRUCE_VERION="1.27.0" \
  CF_CLI_7_VERSION="7.5.0" \
  CF_CLI_8_VERSION="8.5.0" \
  YQ4_VERSION="4.26.1" \
  GOVC_VERSION="0.28.0" \
  CREDHUB_VERSION="2.9.3" \
  TERRAFORM_VERSION="1.3.2" \
  YTT_VERSION="0.32.0" \
  AWS_NUKE_VERSION="2.19.0" \
  TERRASCAN_VERSION="1.15.2" \
  BBR_VERSION="1.9.38"
RUN curl -fL "https://github.com/rebuy-de/aws-nuke/releases/download/v${AWS_NUKE_VERSION}/aws-nuke-v${AWS_NUKE_VERSION}-linux-amd64.tar.gz" | tar -xz --transform=s/-v"${AWS_NUKE_VERSION}"-linux-amd64// -C /usr/local/bin \
  && curl -fL "https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${CREDHUB_VERSION}/credhub-linux-${CREDHUB_VERSION}.tgz" | tar -zx -C /usr/local/bin \
  && curl -fL "https://s3-us-west-1.amazonaws.com/v7-cf-cli-releases/releases/v${CF_CLI_7_VERSION}/cf7-cli_${CF_CLI_7_VERSION}_linux_x86-64.tgz" | tar -zx -C /usr/local/bin cf7 \
  && curl -fL "https://s3-us-west-1.amazonaws.com/v8-cf-cli-releases/releases/v${CF_CLI_8_VERSION}/cf8-cli_${CF_CLI_8_VERSION}_linux_x86-64.tgz" | tar -zx -C /usr/local/bin \
  && curl -fL "https://github.com/mikefarah/yq/releases/download/v${YQ4_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq \
  && curl -fL "https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERION}/spruce-linux-amd64" -o /usr/local/bin/spruce \
  && curl -fL "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-amd64" -o /usr/local/bin/bosh \
  && curl -fL "https://github.com/vmware/govmomi/releases/download/v${GOVC_VERSION}/govc_Linux_x86_64.tar.gz" | tar -zx -C /usr/local/bin \
  && curl -fL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" | zcat > /usr/local/bin/terraform \
  && curl -fL "https://raw.githubusercontent.com/FidelityInternational/fly_wrapper/master/fly" -o /usr/local/bin/fly \
  && curl -fL "https://github.com/vmware-tanzu/carvel-ytt/releases/download/v${YTT_VERSION}/ytt-linux-amd64" -o /usr/local/bin/ytt \
  && curl -fL "https://github.com/tenable/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz" | tar -zx -C /usr/local/bin \
  && curl -fL "https://github.com/cloudfoundry/bosh-backup-and-restore/releases/download/v${BBR_VERSION}/bbr-${BBR_VERSION}-linux-amd64" -o /usr/local/bin/bbr

RUN chmod +x /usr/local/bin/*
RUN mkdir /root/workspace

# Python dependencies
# setuptools needs to be installed separately as a prerequisite for installing other packages
RUN pip install -U setuptools && pip install --no-cache-dir \
  aws-adfs \
  awscli \
  bs4 \
  git+https://github.com/FidelityInternational/nsxramlclient.git@master \
  git+https://github.com/FidelityInternational/pyraml-parser.git@master \
  iso8601 \
  lxml>=4.3.3 \
  mamba>=0.8.6 \
  passlib==1.7.0 \
  PyJWT \
  pytest-cov>=2.10.1 \
  pytest-mock>=3.3.0 \
  pytest>=6.0.1 \
  python-magic>=0.4.18 \
  pytz \
  pyvmomi>=6.0.0.2016.6 \
  pyyaml \
  regex \
  requests \
  ruamel.yaml \
  ruyaml>=0.20.0 \
  s3cmd>=2.1.0 \
  sure>=1.4.0 \
  xmltodict

# AWS Session Manager plugin for the AWS CLI
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" \
  && dpkg -i session-manager-plugin.deb \
  && rm -f session-manager-plugin.deb

# smoke test expected cli tools to ensure they are in the path and executable
RUN aws --version \
  && aws-nuke version \
  && bbr --version \
  && bosh -v \
  && bundler -v \
  && cf -v \
  && cf7 -v \
  && cf8 -v \
  && credhub --version \
  && curl --version \
  && git --version \
  && go version \
  && govc version \
  && jq --version \
  && make --version \
  && psql --version \
  && pyenv -v \
  && python --version \
  && rbenv -v \
  && ruby -v \
  && spruce -v \
  && terraform -v \
  && terrascan version \
  && yq -V \
  && ytt --version \
  && session-manager-plugin --version \
  && bsdtar --version \
  && docker version || echo "Docker Client only" \
  && node --version | grep 16

# install golang libaries
RUN go install github.com/FidelityInternational/stopover@v1.0.2
