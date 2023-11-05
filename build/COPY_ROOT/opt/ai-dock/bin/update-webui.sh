#!/bin/bash

branch=master

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
git checkout ${branch}
git pull

micromamba run -n webui ${PIP_INSTALL} -r requirements_versions.txt