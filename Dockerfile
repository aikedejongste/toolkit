FROM ubuntu:24.04

RUN apt update && apt install ca-certificates apt-transport-https gpg --yes

RUN echo "deb [arch=$(dpkg --print-architecture) trusted=yes] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm.list

ARG PACKAGES="7zip \
              age \
              apache2-utils \
              curl \
              git \
	      helm \
              htop \
              ipcalc \
	      jq \
              rsync \
              rclone \
              sqlfluff \
              vim \
              wget \
              whois"

RUN apt-get update && apt-get install -y $PACKAGES && rm -rf /var/lib/apt/lists/*

RUN wget $(curl -s https://api.github.com/repos/getsops/sops/releases/latest | jq -r '.assets[]' | grep amd64.deb | grep download | awk -F '"' '{print $4}') -O /tmp/sops.deb && dpkg -i /tmp/sops.deb

# terraform
# install latest version of k9s
# install latest version of kubectl
# install latest version of helm
# install latest version of helmfile


