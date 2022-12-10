#!/bin/sh
set -e

USERNAME=vscode
USER_UID=1000
USER_GID=$USER_UID

has_bin() {
    which "${1?bin}" 1>/dev/null 2>&1
}

if ! has_bin sudo; then
     if has:bin yum; then
        yum -y install sudo
     elif has_bin dnf; then
        dnf -y install sudo
     elif has_bin apt; then
        DEBIAN_FRONTEND=noninteractive apt -y install sudo
     elif has_bin apt-get; then
        DEBIAN_FRONTEND=noninteractive apt-get -y install sudo
     elif apk; then
        apk add sudo
     else
        echo "OS not supported" >&2
        exit 1
     fi
fi

# Create the devcontainer user
groupadd --gid $USER_GID $USERNAME
useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Add sudo support. Omit if you don't need to install software after connecting.
echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
chmod 0440 /etc/sudoers.d/$USERNAME
