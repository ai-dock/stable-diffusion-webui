#!/bin/bash

trap cleanup EXIT

function cleanup() {
    kill $(jobs -p) > /dev/null 2>&1
    rm /run/http_ports/$PORT > /dev/null 2>&1
}

if [[ -z $WEBUI_PORT ]]; then
    WEBUI_PORT=7860
fi

PORT=$WEBUI_PORT
METRICS_PORT=1860
SERVICE_NAME="A1111 SD Web UI"

printf "{\"port\": \"$PORT\", \"metrics_port\": \"$METRICS_PORT\", \"service_name\": \"$SERVICE_NAME\"}" > /run/http_ports/$PORT

printf "Starting $SERVICE_NAME...\n"

PLATFORM_FLAGS=""
if [[ $XPU_TARGET = "CPU" ]]; then
    PLATFORM_FLAGS="--use-cpu all --skip-torch-cuda-test --no-half"
fi
# We can safely --skip-prepare-environment because it's already been done
BASE_FLAGS="--listen --port ${WEBUI_PORT} --skip-prepare-environment"

if [[ -f /run/provisioning_script ]]; then
    micromamba run -n fastapi python /opt/ai-dock/fastapi/logviewer/main.py \
        -p $WEBUI_PORT \
        -r 5 \
        -s "${SERVICE_NAME}" \
        -t "Preparing ${SERVICE_NAME}" &
    fastapi_pid=$!
fi
    
while [[ -f /run/provisioning_script ]]; do
    sleep 1
done

cd /opt/stable-diffusion-webui

micromamba run -n webui python launch.py \
    ${PLATFORM_FLAGS} \
    ${BASE_FLAGS} \
    ${WEBUI_FLAGS}
