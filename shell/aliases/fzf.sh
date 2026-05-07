#!/bin/bash

# Fuzzy find with neovim integration
ff() {
    local file
    file=$(fzf --preview="cat {}")
    [[ -n "$file" ]] && nvim "$file"
}
