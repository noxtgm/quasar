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

do_packages() {
    if ! install_core_packages; then
        error "Failed to install core packages."
        exit 1
    fi

    if ! install_yay; then
        error "Failed to install yay."
        exit 1
    fi

    if ! install_aur_packages; then
        error "Failed to install AUR packages."
    fi
}

do_configs() {
    if ! install_all_configs; then
        error "Failed to install configurations."
    fi

    if ! autostart_hyprland; then
        error "Failed to configure Hyprland auto-start."
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

    if [[ "$run_packages" == "true" ]]; then do_packages; fi
    if [[ "$run_configs" == "true" ]];  then do_configs; fi
    if [[ "$run_shell" == "true" ]];    then do_shell; fi

    msg "Installation complete."

    if [[ "$no_reboot" == "false" ]]; then do_reboot; fi
}

main "${INSTALL_ARGS[@]}"
