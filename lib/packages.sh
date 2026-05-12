#!/bin/bash

parse_packages() {
    local file="$1"
    local -n result_array=$2

    [[ -f "$file" ]] || return 1

    local line
    while IFS= read -r line; do
        [[ "$line" =~ ^[[:space:]]*$ ]] && continue
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        result_array+=("$line")
    done < "$file"

    [[ ${#result_array[@]} -eq 0 ]] && return 1
    return 0
}

install_yay() {
    if command -v yay &>/dev/null; then
        msg2 "yay already installed, skipping."
        return 0
    fi

    msg "Installing yay..."

    local yay_dir="${REPO_BUILD:-${REPO_PATH}/.build}/yay-bin"

    if ! git clone https://aur.archlinux.org/yay-bin.git "$yay_dir"; then
        error "Failed to clone yay-bin."
        return 1
    fi

    if ! (cd "$yay_dir" && makepkg -si --noconfirm); then
        error "Failed to build yay-bin."
        rm -rf "$yay_dir"
        return 1
    fi

    rm -rf "$yay_dir"
    msg "Installed yay."
}

install_official_packages() {
    local packages=()
    if ! parse_packages "${REPO_PATH}/packages.official" packages; then
        warning "Official package file not found or empty."
        return 0
    fi

    msg "Installing ${#packages[@]} official package(s)..."
    if ! sudo pacman -S --noconfirm --needed "${packages[@]}"; then
        error "Failed to install official packages."
        return 1
    fi

    msg "Installed ${#packages[@]} official package(s)."
}

install_aur_packages() {
    local packages=()
    if ! parse_packages "${REPO_PATH}/packages.aur" packages; then
        warning "AUR package file not found or empty."
        return 0
    fi

    if ! install_yay; then
        error "Failed to install yay."
        return 1
    fi

    msg "Installing ${#packages[@]} AUR package(s)..."
    if ! yay -S --noconfirm --needed --answerdiff None --answerclean None "${packages[@]}"; then
        error "Failed to install AUR packages."
        return 1
    fi

    msg "Installed ${#packages[@]} AUR package(s)."
}

install_packages() {
    install_official_packages
    install_aur_packages
}
