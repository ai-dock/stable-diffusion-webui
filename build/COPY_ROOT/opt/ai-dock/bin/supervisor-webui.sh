#!/bin/bash

trap 'kill $(jobs -p)' EXIT

if [[ -z $WEBUI_PORT ]]; then
    WEBUI_PORT=7860
fi

printf "Starting webui...\n"

if [[ $CF_QUICK_TUNNELS = "true" ]]; then
    cloudflared tunnel --url localhost:${WEBUI_PORT} > /var/log/supervisor/quicktunnel-webui.log 2>&1 &
fi

PLATFORM_FLAGS=""
if [[ $XPU_TARGET = "CPU" ]]; then
    PLATFORM_FLAGS="--use-cpu all --skip-torch-cuda-test --no-half"
fi
# We can safely --skip-prepare-environment because it's already been done
BASE_FLAGS="--listen --port ${WEBUI_PORT} --skip-prepare-environment"

cd /opt/stable-diffusion-webui

micromamba run -n webui python launch.py \
    ${PLATFORM_FLAGS} \
    ${BASE_FLAGS} \
    ${WEBUI_FLAGS}

