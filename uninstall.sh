#!/bin/bash

set -eo pipefail

REPO_NAME="${REPO_NAME:-quasar}"
REPO_PATH="${HOME}/.local/share/${REPO_NAME}"

if [[ -f "${REPO_PATH}/lib/colors.sh" && -f "${REPO_PATH}/lib/logging.sh" ]]; then
    source "${REPO_PATH}/lib/colors.sh"
    source "${REPO_PATH}/lib/logging.sh"
else
    msg()     { printf "==> %s\n" "$1"; }
    msg2()    { printf "  -> %s\n" "$1"; }
    error()   { printf "==> ERROR: %s\n" "$1" >&2; }
    warning() { printf "==> WARNING: %s\n" "$1"; }
fi

remove_config_symlinks() {
    local removed=0
    while IFS= read -r -d '' link; do
        local target
        target=$(readlink "$link")
        if [[ "$target" == "${REPO_PATH}"* ]]; then
            local bak="${link}.bak"
            rm -f "$link"
            if [[ -f "$bak" ]]; then
                mv "$bak" "$link"
                msg2 "Restored backup: $link."
            fi
            removed=$((removed + 1))
        fi
    done < <(find "${HOME}/.config" -type l -print0 2>/dev/null)
    msg2 "Removed $removed config symlink(s)."
}

remove_shell_config() {
    local bashrc="$HOME/.bashrc"
    local start_marker="# --- ${REPO_NAME} shell ---"
    local end_marker="# --- end ${REPO_NAME} shell ---"
    if [[ -f "$bashrc" ]] && grep -qF "$start_marker" "$bashrc"; then
        sed -i "/$start_marker/,/$end_marker/d" "$bashrc"
        msg2 "Removed shell configuration from .bashrc."
    fi
}

remove_hyprland_autostart() {
    local bash_profile="$HOME/.bash_profile"
    if [[ -f "$bash_profile" ]] && grep -qF 'exec Hyprland' "$bash_profile"; then
        sed -i '/exec Hyprland/d' "$bash_profile"
        msg2 "Removed Hyprland autostart from .bash_profile."
    fi
}

remove_repo() {
    if [[ -d "$REPO_PATH" ]]; then
        rm -rf "$REPO_PATH"
        msg2 "Removed repository at $REPO_PATH."
    fi
}

remove_config_symlinks
remove_shell_config
remove_hyprland_autostart

read -rp "Remove the dotfiles repository at ${REPO_PATH}? [y/N] " response
if [[ "$response" =~ ^[Yy]$ ]]; then
    remove_repo
fi

msg "Uninstall complete."
