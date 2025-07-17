FROM ubuntu:24.04

ARG PACKAGES="curl \
            wget \
            htop \
            vim \
            rsync \
            rclone \
            git"

RUN apt-get update && apt-get install -y $PACKAGES && rm -rf /var/lib/apt/lists/*