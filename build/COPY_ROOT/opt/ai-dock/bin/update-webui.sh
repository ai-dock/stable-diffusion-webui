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
micromamba run -n webui python launch.py --skip-torch-cuda-test --skip-python-version-check --no-download-sd-model --do-not-download-clip --exit