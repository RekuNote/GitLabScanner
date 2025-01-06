#!/bin/bash

SCRIPTDIR="${BASH_SOURCE%/*}"
if [[ ! -d "$SCRIPTDIR" ]]; then SCRIPTDIR="$PWD"; fi
. "$SCRIPTDIR/includes.sh"

if [ -z "$GITLAB_TOKEN" ]; then
    echo "${COLOR_RED}Error: GITLAB_TOKEN environment variable is not set.${COLOR_RESET}" >&2
    exit 1
fi

usage() {
    echo "${COLOR_BOLD}Clone all repositories from all members of a GitLab group${COLOR_RESET}"
    echo "${COLOR_BOLD}Usage:${COLOR_GREEN}${COLOR_DIM}" $0 "<gitlab group name>${COLOR_RESET}"
    echo "${COLOR_BOLD}Example: ${COLOR_GREEN}${COLOR_DIM}"$0" RexiMemo${COLOR_RESET}"
    exit
}

[ -z "$1" ] && usage

GROUPNAME="$1"
USERS=$(curl -sL --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/groups/$GROUPNAME/members" | jq -r '.[].username')

if [ -z "$USERS" ]; then
    echo "${COLOR_RED}Error: No members found for group $GROUPNAME.${COLOR_RESET}" >&2
    exit 1
fi

for orguser in $USERS; do
    echo "${COLOR_BOLD}Cloning repositories from user: $orguser...${COLOR_RESET}"
    "$SCRIPTDIR/clone_user.sh" "$orguser"
done

