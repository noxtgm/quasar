#!/bin/bash

# Link a config file from source to destination
# Returns: 0 = created/updated, 1 = error, 2 = already up-to-date
_link_config() {
    local src="$1"
    local dest="$2"
    local dest_dir
    dest_dir=$(dirname "$dest")

    # Validate source file exists
    if [[ ! -e "$src" ]]; then
        log_error "Source file does not exist: $src"
        return 1
    fi

    # Skip if symlink already points to correct target
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        return 2
    fi

    # Create destination directory
    if ! mkdir -p "$dest_dir"; then
        log_error "Failed to create directory: $dest_dir"
        return 1
    fi

    # Backup existing file (not symlink)
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        if ! cp "$dest" "${dest}.bak"; then
            log_error "Failed to backup: $dest"
            return 1
        fi
        log_info "Backed up: $dest"
    fi

    # Remove existing file or symlink
    [[ -e "$dest" || -L "$dest" ]] && rm -f "$dest"

    # Create symlink
    if ! ln -s "$src" "$dest"; then
        log_error "Failed to link: $src -> $dest"
        return 1
    fi
}

# Link all files from source directory to ~/.config
_link_config_files() {
    local source_dir="$1"
    local linked=0
    local skipped=0

    if [[ -z "$source_dir" || ! -d "$source_dir" ]]; then
        log_error "Invalid source directory: $source_dir."
        return 1
    fi

    while IFS= read -r -d '' src_file; do
        local relative_path="${src_file#"$REPO_CONFIG"/}"
        local dest_file="${HOME}/.config/${relative_path}"

        _link_config "$src_file" "$dest_file"
        case $? in
            0) linked=$((linked + 1)) ;;
            2) skipped=$((skipped + 1)) ;;
            *) log_warning "Failed to link: $dest_file" ;;
        esac
    done < <(find "$source_dir" -type f -print0)

    if [[ $linked -gt 0 ]]; then
        log_success "Linked $linked file(s), $skipped already up-to-date."
    elif [[ $skipped -gt 0 ]]; then
        log_info "All $skipped file(s) already up-to-date."
    else
        log_warning "No files to link."
    fi
}

# Install configs for a specific application
# Usage: install_config <config_name>
# Example: install_config hypr → installs config/hypr/* to ~/.config/hypr/*
install_config() {
    local config_name="$1"
    local config_path="$REPO_CONFIG/$config_name"
    
    if [[ ! -d "$config_path" ]]; then
        log_error "Config '$config_name' not found."
        return 1
    fi
    
    _link_config_files "$config_path"
}

# Remove symlinks in ~/.config that point into REPO_PATH but no longer have a source file
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
        log_info "Pruned $pruned stale symlink(s)."
    fi
}

# Install all configs
install_all_configs() {
    if [[ ! -d "$REPO_CONFIG" ]]; then
        log_warning "Config directory not found: $REPO_CONFIG."
        return 0
    fi

    _prune_stale_symlinks
    _link_config_files "$REPO_CONFIG"
}
