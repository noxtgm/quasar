#!/bin/bash

REPO_LOG="${REPO_PATH}/${REPO_NAME}.log"

_log_file() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $2" >> "$REPO_LOG" 2>/dev/null
}

msg() {
    printf "${GREEN}==>${ALL_OFF}${BOLD} %s${ALL_OFF}\n" "$1"
    _log_file "MSG" "$1"
}

msg2() {
    printf "${BLUE}  ->${ALL_OFF}${BOLD} %s${ALL_OFF}\n" "$1"
    _log_file "INFO" "$1"
}

warning() {
    printf "${YELLOW}==> WARNING:${ALL_OFF}${BOLD} %s${ALL_OFF}\n" "$1"
    _log_file "WARNING" "$1"
}

error() {
    printf "${RED}==> ERROR:${ALL_OFF}${BOLD} %s${ALL_OFF}\n" "$1" >&2
    _log_file "ERROR" "$1"
}
