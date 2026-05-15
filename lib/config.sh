#!/bin/bash

declare -A _CONFIG_TARGET_MAP=(
    ["librewolf"]="${HOME}/.librewolf"
)

declare -A _CONFIG_SYSTEM_MAP=(
    ["librewolf/policies.json"]="/usr/lib/librewolf/distribution/policies.json"
)

_resolve_config_dest() {
    local relative_path="$1"
    local top_dir="${relative_path%%/*}"

    if [[ -n "${_CONFIG_SYSTEM_MAP[$relative_path]+x}" ]]; then
        return 1
    fi

    if [[ -n "${_CONFIG_TARGET_MAP[$top_dir]+x}" ]]; then
        local sub_path="${relative_path#"$top_dir"/}"
        echo "${_CONFIG_TARGET_MAP[$top_dir]}/${sub_path}"
    else
        echo "${HOME}/.config/${relative_path}"
    fi
}

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
        local dest_file
        dest_file=$(_resolve_config_dest "$relative_path") || continue

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
    local search_dirs=("${HOME}/.config")

    for target_dir in "${_CONFIG_TARGET_MAP[@]}"; do
        [[ -d "$target_dir" ]] && search_dirs+=("$target_dir")
    done

    for search_dir in "${search_dirs[@]}"; do
        while IFS= read -r -d '' link; do
            local target
            target=$(readlink "$link")
            if [[ "$target" == "$REPO_CONFIG"* && ! -e "$target" ]]; then
                rm -f "$link"
                pruned=$((pruned + 1))
            fi
        done < <(find "$search_dir" -type l -print0 2>/dev/null)
    done

    if [[ $pruned -gt 0 ]]; then
        msg2 "Pruned $pruned stale symlink(s)."
    fi
}

_link_system_configs() {
    local filter="$1"
    local linked=0
    local skipped=0

    for relative_path in "${!_CONFIG_SYSTEM_MAP[@]}"; do
        if [[ -n "$filter" && "$relative_path" != "$filter"/* ]]; then
            continue
        fi

        local src="${REPO_CONFIG}/${relative_path}"
        local dest="${_CONFIG_SYSTEM_MAP[$relative_path]}"
        local dest_dir
        dest_dir=$(dirname "$dest")

        [[ ! -e "$src" ]] && continue

        if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
            skipped=$((skipped + 1))
            continue
        fi

        sudo mkdir -p "$dest_dir"

        if [[ -e "$dest" && ! -L "$dest" ]]; then
            sudo cp "$dest" "${dest}.bak"
            msg2 "Backed up $dest."
        fi

        [[ -e "$dest" || -L "$dest" ]] && sudo rm -f "$dest"

        if sudo ln -s "$src" "$dest"; then
            linked=$((linked + 1))
        else
            warning "Failed to link system config: $dest."
        fi
    done

    if [[ $linked -gt 0 ]]; then
        msg "Linked $linked system config(s), $skipped already up-to-date."
    elif [[ $skipped -gt 0 ]]; then
        msg2 "All $skipped system config(s) already up-to-date."
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
    _link_system_configs "$config_name"
}

install_all_configs() {
    if [[ ! -d "$REPO_CONFIG" ]]; then
        warning "Config directory not found: $REPO_CONFIG."
        return 0
    fi

    _prune_stale_symlinks
    _link_config_files "$REPO_CONFIG"
    _link_system_configs
}
