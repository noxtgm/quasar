#!/bin/bash

# Returns: 0 = created/updated, 1 = error, 2 = already up-to-date
_link_config() {
    local src="$1"
    local dest="$2"
    local dest_dir
    dest_dir=$(dirname "$dest")

    if [[ ! -e "$src" ]]; then
        error "Source does not exist: $src."
        return 1
    fi

    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        return 2
    fi

    if ! mkdir -p "$dest_dir"; then
        error "Failed to create directory: $dest_dir."
        return 1
    fi

    if [[ -e "$dest" && ! -L "$dest" ]]; then
        if ! cp "$dest" "${dest}.bak"; then
            error "Failed to back up: $dest."
            return 1
        fi
        msg2 "Backed up $dest."
    fi

    [[ -e "$dest" || -L "$dest" ]] && rm -f "$dest"

    if ! ln -s "$src" "$dest"; then
        error "Failed to link: $src -> $dest."
        return 1
    fi
}

_link_config_files() {
    local source_dir="$1"
    local linked=0
    local skipped=0

    if [[ -z "$source_dir" || ! -d "$source_dir" ]]; then
        error "Invalid source directory: $source_dir."
        return 1
    fi

    while IFS= read -r -d '' src_file; do
        local relative_path="${src_file#"$REPO_CONFIG"/}"
        local dest_file="${HOME}/.config/${relative_path}"

        local rc=0
        _link_config "$src_file" "$dest_file" || rc=$?
        case $rc in
            0) linked=$((linked + 1)) ;;
            2) skipped=$((skipped + 1)) ;;
            *) warning "Failed to link: $dest_file." ;;
        esac
    done < <(find "$source_dir" -type f -print0)

    if [[ $linked -gt 0 ]]; then
        msg "Linked $linked file(s), $skipped already up-to-date."
    elif [[ $skipped -gt 0 ]]; then
        msg2 "All $skipped file(s) already up-to-date."
    else
        warning "No files to link."
    fi
}

_prune_stale_symlinks() {
    local pruned=0

    while IFS= read -r -d '' link; do
        local target
        target=$(readlink "$link")
        if [[ "$target" == "$REPO_CONFIG"* && ! -e "$target" ]]; then
            rm -f "$link"
            pruned=$((pruned + 1))
        fi
    done < <(find "${HOME}/.config" -type l -print0 2>/dev/null)

    if [[ $pruned -gt 0 ]]; then
        msg2 "Pruned $pruned stale symlink(s)."
    fi
}

install_config() {
    local config_name="$1"
    local config_path="$REPO_CONFIG/$config_name"

    if [[ ! -d "$config_path" ]]; then
        error "Config not found: $config_name."
        return 1
    fi

    _link_config_files "$config_path"
}

install_all_configs() {
    if [[ ! -d "$REPO_CONFIG" ]]; then
        warning "Config directory not found: $REPO_CONFIG."
        return 0
    fi

    _prune_stale_symlinks
    _link_config_files "$REPO_CONFIG"
}
