#!/bin/bash

refresh_config() {
    local config_path="$1"
    local source_file="${REPO_CONFIG}/${config_path}"
    local dest_file="${HOME}/.config/${config_path}"

    if [[ ! -f "$source_file" ]]; then
        error "Config not found in repo: ${config_path}."
        return 1
    fi

    if [[ -L "$dest_file" && "$(readlink "$dest_file")" == "$source_file" ]]; then
        msg2 "Already up to date: ${config_path}."
        return 0
    fi

    local backup=""
    if [[ -f "$dest_file" || -L "$dest_file" ]]; then
        backup="${dest_file}.bak.$(date +%s)"
        cp -P "$dest_file" "$backup"
    fi

    mkdir -p "$(dirname "$dest_file")"
    rm -f "$dest_file"
    ln -s "$source_file" "$dest_file"

    if [[ -n "$backup" && -f "$backup" ]]; then
        if cmp -s "$source_file" "$backup" 2>/dev/null; then
            rm -f "$backup"
            msg "Refreshed ${config_path}."
        else
            msg "Refreshed ${config_path}."
            msg2 "Backup saved: ${backup}."
            diff --color=auto "$backup" "$source_file" 2>/dev/null || true
        fi
    else
        msg "Linked ${config_path}."
    fi
}

refresh_app() {
    local app_name="$1"
    local app_dir="${REPO_CONFIG}/${app_name}"

    if [[ ! -d "$app_dir" ]]; then
        error "Config not found: ${app_name}."
        list_configs
        return 1
    fi

    local count=0
    while IFS= read -r -d '' src_file; do
        local relative="${src_file#"$REPO_CONFIG"/}"
        refresh_config "$relative"
        count=$((count + 1))
    done < <(find "$app_dir" -type f -print0)

    if [[ $count -eq 0 ]]; then
        warning "No config files found for ${app_name}."
    fi
}

list_configs() {
    if [[ ! -d "$REPO_CONFIG" ]]; then
        warning "No config directory found."
        return 0
    fi

    msg2 "Available configs:"
    local app
    for app_dir in "$REPO_CONFIG"/*/; do
        [[ -d "$app_dir" ]] || continue
        app=$(basename "$app_dir")
        local count
        count=$(find "$app_dir" -type f | wc -l)
        echo "  ${app} (${count} file(s))"
    done
}
