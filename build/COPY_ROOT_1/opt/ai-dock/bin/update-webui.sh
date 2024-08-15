#!/bin/bash
umask 002

source /opt/ai-dock/bin/venv-set.sh webui

if [[ -n "${WEBUI_REF}" ]]; then
    ref="${WEBUI_REF}"
else
    # The latest tagged release
    ref="$(curl -s https://api.github.com/repos/AUTOMATIC1111/stable-diffusion-webui/tags | \
            jq -r '.[0].name')"
fi

# -r argument has priority
while getopts r: flag
do
    case "${flag}" in
        r) ref="$OPTARG";;
    esac
done

[[ -n $ref ]] || { echo "Failed to get update target"; exit 1; }

printf "Updating A1111 WebUI (${ref})...\n"

cd /opt/stable-diffusion-webui
git fetch --tags
git checkout ${ref}
git pull

"$WEBUI_VENV_PIP" install --no-cache-dir -r requirements.txt
