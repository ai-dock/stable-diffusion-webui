#!/bin/bash
umask 002
branch=master

source /opt/ai-dock/bin/venv-set.sh webui

if [[ -n "${WEBUI_BRANCH}" ]]; then
    branch="${WEBUI_BRANCH}"
fi

# -b flag has priority
while getopts b: flag
do
    case "${flag}" in
        b) branch="$OPTARG";;
    esac
done

printf "Updating stable-diffusion-webui (${branch})...\n"

cd /opt/stable-diffusion-webui
git fetch --tags
git checkout ${branch}
git pull

"$WEBUI_VENV_PIP" install --no-cache-dir -r requirements_versions.txt
