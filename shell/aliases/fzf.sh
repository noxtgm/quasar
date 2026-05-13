#!/bin/bash

if command -v fzf &>/dev/null; then
    ff() {
        local preview="cat {}"
        command -v bat &>/dev/null && preview="bat --color=always --style=numbers {}"
        local file
        file=$(fzf --preview="$preview")
        [[ -n "$file" ]] && nvim "$file"
    }

    fg() {
        local selection
        selection=$(rg --color=always --line-number --no-heading . | \
            fzf --ansi --delimiter=: --preview="bat --color=always --style=numbers --highlight-line={2} {1} 2>/dev/null || cat {1}" --preview-window=+{2}-/2)
        if [[ -n "$selection" ]]; then
            local file="${selection%%:*}"
            local line="${selection#*:}"
            line="${line%%:*}"
            nvim "+$line" "$file"
        fi
    }
fi
