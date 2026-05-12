#!/bin/bash

if command -v fzf &>/dev/null; then
    ff() {
        local file
        file=$(fzf --preview="cat {}")
        [[ -n "$file" ]] && nvim "$file"
    }
fi
