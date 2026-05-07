#!/bin/bash

set -eo pipefail

# Define environment paths
export REPO_NAME="${REPO_NAME:-labs-dotfiles}"
export REPO_AUTHOR="${REPO_AUTHOR:-noxtgm}"
export REPO_PATH="${HOME}/.local/share/${REPO_NAME}"
export REPO_INSTALL="${REPO_PATH}/install"
export REPO_CONFIG="${REPO_PATH}/config"
export REPO_SHELL="${REPO_PATH}/shell"
export REPO_LIB="${REPO_PATH}/lib"

# Install git if not present
if ! command -v git &>/dev/null; then
    sudo pacman -S --noconfirm --needed git
fi

# Check if execution is reinstalling
export IS_REINSTALL=false
if [[ -d "${REPO_PATH}" ]]; then
    IS_REINSTALL=true
fi

# Remove previously existing installation if reinstalling
if [[ "$IS_REINSTALL" == "true" ]]; then
    rm -rf "${REPO_PATH}"
fi

# Clone repository
if ! git clone "https://github.com/${REPO_AUTHOR}/${REPO_NAME}.git" "${REPO_PATH}"; then
    echo -e "\033[0;31m[ERROR] Failed to clone repository.\033[0m"
    exit 1
fi

# Source shared libraries
source "${REPO_LIB}/init.sh"

# Run installation process
source "${REPO_PATH}/install.sh"
