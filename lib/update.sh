#!/bin/bash

do_update() {
    local force=false
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --force) force=true ;;
            *) error "Unknown option: $1."; return 1 ;;
        esac
        shift
    done

    msg "Checking for updates..."

    local old_version
    old_version=$(cat "${REPO_PATH}/version" 2>/dev/null || echo "unknown")

    local old_head
    old_head=$(git -C "${REPO_PATH}" rev-parse HEAD)

    if [[ "$force" == "true" ]]; then
        git -C "${REPO_PATH}" reset --hard HEAD --quiet
        git -C "${REPO_PATH}" clean -fd --quiet
    fi

    if ! git -C "${REPO_PATH}" pull --quiet; then
        error "Failed to pull updates."
        return 1
    fi

    local new_head
    new_head=$(git -C "${REPO_PATH}" rev-parse HEAD)

    if [[ "$old_head" == "$new_head" ]]; then
        msg2 "Already up to date (v${old_version})."
        return 0
    fi

    msg2 "Applying changes..."

    install_all_configs
    configure_shell

    local new_version
    new_version=$(cat "${REPO_PATH}/version" 2>/dev/null || echo "unknown")
    msg "Updated v${old_version} to v${new_version}."
}
