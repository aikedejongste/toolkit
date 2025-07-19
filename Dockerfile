FROM ubuntu:24.04

ARG PACKAGES="7zip \
              age \
              apache2-utils \
              curl \
              htop \
              ipcalc \
              rsync \
              rclone \
              git \
              sqlfluff \
              vim \
              wget \
              whois"
# sops
# terraform
# k9s

RUN apt-get update && apt-get install -y $PACKAGES && rm -rf /var/lib/apt/lists/*
