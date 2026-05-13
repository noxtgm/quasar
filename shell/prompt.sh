#!/bin/bash

__prompt_git() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return

    local status=""
    local git_status
    git_status=$(git status --porcelain=v1 2>/dev/null)

    local staged=0 modified=0 untracked=0
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local x="${line:0:1}" y="${line:1:1}"
        [[ "$x" != " " && "$x" != "?" ]] && staged=$((staged + 1))
        [[ "$y" != " " && "$y" != "?" ]] && modified=$((modified + 1))
        [[ "$x" == "?" ]] && untracked=$((untracked + 1))
    done <<< "$git_status"

    [[ $staged -gt 0 ]] && status+=" +${staged}"
    [[ $modified -gt 0 ]] && status+=" ~${modified}"
    [[ $untracked -gt 0 ]] && status+=" ?${untracked}"

    printf '%s' " ${branch}${status} "
}

__prompt_command() {
    local exit_code=$?

    local reset='\[\e[0m\]'

    local blue_bg='\[\e[44m\]'
    local blue_fg='\[\e[34m\]'
    local orange_bg='\[\e[48;2;255;146;72m\]'
    local orange_fg='\[\e[38;2;255;146;72m\]'
    local yellow_bg='\[\e[48;2;255;251;56m\]'
    local yellow_fg='\[\e[38;2;255;251;56m\]'
    local dark_fg='\[\e[30m\]'
    local white_fg='\[\e[97m\]'
    local green_fg='\[\e[32m\]'
    local red_fg='\[\e[31m\]'

    local sep=$''

    local git_info
    git_info=$(__prompt_git)

    PS1=""

    # Shell segment
    PS1+="${blue_bg}${white_fg}  bash "

    if [[ -n "$git_info" ]]; then
        # Blue -> Orange
        PS1+="${orange_bg}${blue_fg}${sep}${reset}"
        # Path segment
        PS1+="${orange_bg}${dark_fg}  \W "
        # Orange -> Yellow
        PS1+="${yellow_bg}${orange_fg}${sep}${reset}"
        # Git segment
        PS1+="${yellow_bg}${dark_fg}${git_info}"
        # Yellow -> reset
        PS1+="${reset}${yellow_fg}${sep}${reset}"
    else
        # Blue -> Orange
        PS1+="${orange_bg}${blue_fg}${sep}${reset}"
        # Path segment
        PS1+="${orange_bg}${dark_fg}  \W "
        # Orange -> reset
        PS1+="${reset}${orange_fg}${sep}${reset}"
    fi

    PS1+="\n"

    # Prompt indicator
    if [[ $exit_code -eq 0 ]]; then
        PS1+="${green_fg}❯${reset} "
    else
        PS1+="${red_fg}❯${reset} "
    fi
}

PROMPT_COMMAND=__prompt_command
