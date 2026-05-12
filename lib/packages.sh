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

install_packages() {
    local packages=()
    if ! parse_packages "${REPO_PATH}/packages" packages; then
        warning "Package file not found or empty."
        return 0
    fi

    local official=()
    local aur=()

    msg "Classifying packages..."
    for pkg in "${packages[@]}"; do
        if pacman -Si "$pkg" &>/dev/null; then
            official+=("$pkg")
        else
            aur+=("$pkg")
        fi
    done
    msg2 "${#official[@]} official, ${#aur[@]} AUR."

    if [[ ${#official[@]} -gt 0 ]]; then
        msg "Installing official packages..."
        if ! sudo pacman -S --noconfirm --needed "${official[@]}"; then
            error "Failed to install official packages."
            return 1
        fi
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        if ! install_yay; then
            error "Failed to install yay."
            return 1
        fi

        msg "Installing AUR packages..."
        if ! yay -S --noconfirm --needed --answerdiff None --answerclean None "${aur[@]}"; then
            error "Failed to install AUR packages."
            return 1
        fi
    fi

    msg "Installed ${#official[@]} official and ${#aur[@]} AUR package(s)."
}
