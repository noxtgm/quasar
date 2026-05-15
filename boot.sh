#!/bin/bash

set -euo pipefail

# Define environment paths
export REPO_NAME="${REPO_NAME:-quasar}"
export REPO_AUTHOR="${REPO_AUTHOR:-noxtgm}"
export REPO_PATH="${HOME}/.local/share/${REPO_NAME}"
export REPO_BUILD="${REPO_PATH}/.build"
export REPO_CONFIG="${REPO_PATH}/config"
export REPO_SHELL="${REPO_PATH}/shell"
export REPO_LIB="${REPO_PATH}/lib"

cleanup() {
    if [[ -d "${REPO_PATH}.bak" ]]; then
        rm -rf "${REPO_PATH}"
        mv "${REPO_PATH}.bak" "${REPO_PATH}"
        printf "\e[1;34m  ->\e[0m\e[1m Restored previous installation.\e[0m\n"
    fi
}

trap 'printf "\e[1;31m==> ERROR:\e[0m\e[1m Failed at line %s.\e[0m\n" "$LINENO" >&2; cleanup; exit 1' ERR

# Install git if not present
if ! command -v git &>/dev/null; then
    sudo pacman -S --noconfirm --needed git
fi

# Check if execution is reinstalling
IS_REINSTALL=false
if [[ -d "${REPO_PATH}" ]]; then
    IS_REINSTALL=true
fi

# Move existing installation aside if reinstalling
if [[ "$IS_REINSTALL" == "true" ]]; then
    mv "${REPO_PATH}" "${REPO_PATH}.bak"
fi

# Clone repository
if ! git clone --depth 1 "https://github.com/${REPO_AUTHOR}/${REPO_NAME}.git" "${REPO_PATH}"; then
    printf "\e[1;31m==> ERROR:\e[0m\e[1m Failed to clone repository.\e[0m\n" >&2
    cleanup
    exit 1
fi

# Validate cloned repo structure
if [[ ! -f "${REPO_LIB}/init.sh" ]]; then
    printf "\e[1;31m==> ERROR:\e[0m\e[1m Cloned repo is missing lib/init.sh.\e[0m\n" >&2
    cleanup
    exit 1
fi

if [[ -d "${REPO_PATH}/bin" ]]; then
    chmod +x "${REPO_PATH}/bin/"*
fi

INSTALL_ARGS=("$@")

# Source shared libraries
source "${REPO_LIB}/init.sh"

# Run installation process
source "${REPO_PATH}/install.sh"

[[ -d "${REPO_PATH}.bak" ]] && rm -rf "${REPO_PATH}.bak"
