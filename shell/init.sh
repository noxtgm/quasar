#!/bin/bash

REPO_SHELL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -f "${REPO_SHELL}/prompt.sh" ]] && . "${REPO_SHELL}/prompt.sh"
[[ -f "${REPO_SHELL}/settings.sh" ]] && . "${REPO_SHELL}/settings.sh"

for file in "${REPO_SHELL}/aliases"/*.sh; do
    [[ -f "$file" ]] && . "$file"
done
