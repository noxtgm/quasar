#!/bin/bash

set -eo pipefail
trap 'error "Failed at line $LINENO."; exit 1' ERR

if ! declare -f error &>/dev/null; then
    # Raw ANSI — lib not sourced yet when running standalone
    printf "\e[1;31m==> ERROR:\e[0m\e[1m Cannot run standalone. Use boot.sh instead.\e[0m\n" >&2
    exit 1
fi

usage() {
    echo "Usage: boot.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --packages    Install packages only"
    echo "  --configs     Install configs only"
    echo "  --shell       Configure shell only"
    echo "  --no-reboot   Skip reboot after install"
    echo "  -h, --help    Show this help message"
    echo ""
    echo "No flags runs the full installation."
}

do_git_setup() {
    msg "Git configuration"

    local name email

    read -rp "  Enter your Git username: " name
    while [[ -z "$name" ]]; do
        warning "Username cannot be empty."
        read -rp "  Enter your Git username: " name
    done

    read -rp "  Enter your Git email: " email
    while [[ -z "$email" ]]; do
        warning "Email cannot be empty."
        read -rp "  Enter your Git email: " email
    done

    git config --global user.name "$name"
    git config --global user.email "$email"

    msg2 "Git configured as $name <$email>."
}

do_packages() {
    if ! install_packages; then
        error "Failed to install packages."
        exit 1
    fi
    
    install_npm_packages
}

do_configs() {
    if ! install_all_configs; then
        error "Failed to install configurations."
        exit 1
    fi

    if ! autostart_hyprland; then
        error "Failed to configure Hyprland auto-start."
        exit 1
    fi
}

do_shell() {
    if ! configure_shell; then
        error "Failed to configure shell."
    fi
}

do_reboot() {
    read -rp "Reboot now? [y/N] " response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        return
    fi

    msg2 "Rebooting in 3 seconds..."
    msg2 "Press Ctrl+C to cancel."
    sleep 3
    sudo reboot
}

main() {
    local run_packages=false
    local run_configs=false
    local run_shell=false
    local no_reboot=false
    local selective=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --packages)  run_packages=true; selective=true ;;
            --configs)   run_configs=true; selective=true ;;
            --shell)     run_shell=true; selective=true ;;
            --no-reboot) no_reboot=true ;;
            -h|--help)   usage; exit 0 ;;
            *) error "Unknown option: $1."; usage; exit 1 ;;
        esac
        shift
    done

    if [[ "$selective" == "false" ]]; then
        run_packages=true
        run_configs=true
        run_shell=true
    fi

    if [[ "$IS_REINSTALL" == "false" ]]; then do_git_setup; fi

    if [[ "$run_packages" == "true" ]]; then do_packages; fi
    if [[ "$run_configs" == "true" ]];  then do_configs; fi
    if [[ "$run_shell" == "true" ]];    then do_shell; fi

    msg "Installation complete."

    if [[ "$no_reboot" == "false" ]]; then do_reboot; fi
}

main "${INSTALL_ARGS[@]}"
