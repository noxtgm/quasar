#!/bin/bash

if [[ -z "$REPO_PATH" ]]; then
    REPO_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi
export REPO_PATH

[[ ":$PATH:" != *":${REPO_PATH}/bin:"* ]] && export PATH="${REPO_PATH}/bin:${PATH}"

HISTSIZE=100
HISTFILESIZE=100
