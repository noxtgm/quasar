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

_install_packages() {
    local name="$1"
    local package_file="$2"
    shift 2
    local install_cmd=("$@")

    local packages=()
    if ! parse_packages "$package_file" packages; then
        warning "Package file not found or empty: $package_file."
        return 0
    fi

    msg "Installing $name packages..."

    if ! "${install_cmd[@]}" "${packages[@]}"; then
        error "Failed to install $name packages."
        return 1
    fi

    msg "Installed $name packages."
}

install_yay() {
    if command -v yay &>/dev/null; then
        msg2 "yay already installed, skipping."
        return 0
    fi

    msg "Installing yay..."

    local yay_dir="${REPO_BUILD:-${REPO_PATH}/.build}/yay"

    if ! git clone https://aur.archlinux.org/yay.git "$yay_dir"; then
        error "Failed to clone yay."
        return 1
    fi

    if ! (cd "$yay_dir" && makepkg -si --noconfirm); then
        error "Failed to build yay."
        rm -rf "$yay_dir"
        return 1
    fi

    rm -rf "$yay_dir"
    msg "Installed yay."
}

install_core_packages() {
    _install_packages "core" "${REPO_PATH}/packages.core" \
        sudo pacman -S --noconfirm --needed
}

install_aur_packages() {
    _install_packages "AUR" "${REPO_PATH}/packages.aur" \
        yay -S --noconfirm --needed --answerdiff None --answerclean None
}
