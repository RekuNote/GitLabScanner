#!/bin/bash

SCRIPTDIR="${BASH_SOURCE%/*}"
if [[ ! -d "$SCRIPTDIR" ]]; then SCRIPTDIR="$PWD"; fi
. "$SCRIPTDIR/includes.sh"

if [ -z "$GITLAB_TOKEN" ]; then
    echo "${COLOR_RED}Error: GITLAB_TOKEN environment variable is not set.${COLOR_RESET}" >&2
    exit 1
fi

usage() {
    echo "${COLOR_BOLD}Clone all repositories from a GitLab user${COLOR_RESET}"
    echo "${COLOR_BOLD}Usage:${COLOR_GREEN}${COLOR_DIM}" $0 "<gitlab username>${COLOR_RESET}"
    echo "${COLOR_BOLD}Example: ${COLOR_GREEN}${COLOR_DIM}"$0" RekuNote${COLOR_RESET}"
    exit
}

[ -z "$1" ] && usage

USERNAME="$1"
REPOS=$(curl -sL --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/users/$USERNAME/projects?per_page=100" | jq -r '.[].ssh_url_to_repo')

if [ -z "$REPOS" ]; then
    echo "${COLOR_RED}Error: No repositories found for user $USERNAME.${COLOR_RESET}" >&2
    exit 1
fi

BASE_DIR="$SCRIPTDIR/repositories/git@gitlab.com/$USERNAME"
mkdir -p "$BASE_DIR"

for repo in $REPOS; do
    REPO_NAME=$(basename "$repo" .git)
    TARGET_DIR="$BASE_DIR/$REPO_NAME"

    echo "${COLOR_BOLD}Cloning repository: $repo${COLOR_RESET}"
    if [ -d "$TARGET_DIR" ]; then
        echo "${COLOR_YELLOW}Repository already exists. Pulling latest changes...${COLOR_RESET}"
        git -C "$TARGET_DIR" pull
    else
        git clone "$repo" "$TARGET_DIR"
    fi
done

