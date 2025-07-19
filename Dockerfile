FROM ubuntu:24.04

RUN apt update && apt install ca-certificates apt-transport-https gpg gnupg software-properties-common lsb-release curl --yes

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg
RUN curl -fsSL https://baltocdn.com/helm/signing.asc | gpg --dearmor -o /usr/share/keyrings/helm.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm.list
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

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
	      terraform \
              vim \
	      wget \
              whois"

RUN apt-get update && apt-get install -y $PACKAGES && rm -rf /var/lib/apt/lists/*

# SOPS
RUN wget $(curl -s https://api.github.com/repos/getsops/sops/releases/latest | jq -r '.assets[]' | grep amd64.deb | grep download | awk -F '"' '{print $4}') -O /tmp/sops.deb && dpkg -i /tmp/sops.deb

# Helmfile
#RUN cd /tmp && curl -LO "https://github.com/helmfile/helmfile/releases/latest/download/helmfile_linux_amd64.tar.gz" && tar -xzf helmfile_linux_amd64.tar.gz && mv helmfile /usr/local/bin/helmfile && chmod +x /usr/local/bin/helmfile

# install latest version of k9s
# install latest version of kubectl
# install latest version of helmfile


