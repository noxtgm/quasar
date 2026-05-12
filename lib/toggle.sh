#!/bin/bash

toggle() {
    local feature="$1"

    if [[ -z "$feature" ]]; then
        list_toggles
        return 0
    fi

    local toggle_script="${REPO_PATH}/toggles/${feature}.sh"

    if [[ ! -f "$toggle_script" ]]; then
        error "Unknown toggle: ${feature}."
        list_toggles
        return 1
    fi

    source "$toggle_script"
}

list_toggles() {
    local toggle_dir="${REPO_PATH}/toggles"

    if [[ ! -d "$toggle_dir" ]]; then
        warning "No toggles directory found."
        return 0
    fi

    local found=false
    msg2 "Available toggles:"
    local file
    for file in "$toggle_dir"/*.sh; do
        [[ -f "$file" ]] || continue
        found=true
        local name
        name=$(basename "$file" .sh)
        local desc=""
        local first_comment
        first_comment=$(sed -n '2s/^# *//p' "$file")
        [[ -n "$first_comment" ]] && desc=" — ${first_comment}"
        echo "  ${name}${desc}"
    done

    if [[ "$found" == "false" ]]; then
        msg2 "No toggles available."
    fi
}
