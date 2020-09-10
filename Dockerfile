FROM ubuntu:20.04

LABEL maintainer="henrique.schmidt@somosphi.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV UBUNTU_VERSION=20.04

# Install deps
RUN apt-get update && \
    apt-get install -y bash \
      git \
      tzdata \
      curl \
      zip \
      python \
      apt-transport-https \
      ca-certificates \
      gnupg-agent \
      software-properties-common \
      lsb-release \
      gnupg

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get install -y docker-ce-cli

# Install AWS CLI
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py && \
    pip install --upgrade pip && \
    pip install awscli --upgrade

# Install Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install azure-cli -y

# Install Dotnet
RUN curl https://packages.microsoft.com/config/ubuntu/${UBUNTU_VERSION}/packages-microsoft-prod.deb -o packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-3.1 && \
    rm packages-microsoft-prod.deb
