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

# DRA
RUN wget https://github.com/devmatteini/dra/releases/download/0.8.2/dra_0.8.2-1_amd64.deb && dpkg -i dra_0.8.2-1_amd64.deb && rm dra_0.8.2-1_amd64.deb

# SOPS
RUN wget $(curl -s https://api.github.com/repos/getsops/sops/releases/latest | jq -r '.assets[]' | grep amd64.deb | grep download | awk -F '"' '{print $4}') -O /tmp/sops.deb && dpkg -i /tmp/sops.deb

# Helmfile
ENV DRA_DISABLE_GITHUB_AUTHENTICATION=true 
RUN dra download --install --select "helmfile_{tag}_linux_amd64.tar.gz" --output /usr/local/bin helmfile/helmfile

# install latest version of k9s
RUN dra download --install --select "k9s_linux_amd64.deb" --output /usr/local/bin derailed/k9s

# install latest version of kubectl
RUN curl -sL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# install glab
RUN curl -s "https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases" | jq -r '.[0].assets.links[] | select(.name | endswith("_linux_amd64.deb")).direct_asset_url' | wget -i - && dpkg -i glab*.deb && rm glab*.deb