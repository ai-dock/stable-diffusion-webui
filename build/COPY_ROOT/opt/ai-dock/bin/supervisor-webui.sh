#!/bin/bash

trap cleanup EXIT

LISTEN_PORT=17860
METRICS_PORT=27860
PROXY_SECURE=true

function cleanup() {
    kill $(jobs -p) > /dev/null 2>&1
    rm /run/http_ports/$PORT > /dev/null 2>&1
}

if [[ -z $WEBUI_PORT ]]; then
    WEBUI_PORT=7860
fi

PROXY_PORT=$WEBUI_PORT
SERVICE_NAME="A1111 SD Web UI"

file_content="$(
  jq --null-input \
    --arg listen_port "${LISTEN_PORT}" \
    --arg metrics_port "${METRICS_PORT}" \
    --arg proxy_port "${PROXY_PORT}" \
    --arg proxy_secure "${PROXY_SECURE,,}" \
    --arg service_name "${SERVICE_NAME}" \
    '$ARGS.named'
)"

printf "%s" "$file_content" > /run/http_ports/$PROXY_PORT

printf "Starting $SERVICE_NAME...\n"

PLATFORM_FLAGS=""
if [[ $XPU_TARGET = "CPU" ]]; then
    PLATFORM_FLAGS="--use-cpu all --skip-torch-cuda-test --no-half"
fi
# We can safely --skip-prepare-environment because it's already been done
BASE_FLAGS="--port ${LISTEN_PORT} --skip-prepare-environment"

# Delay launch until micromamba is ready
if [[ -f /run/workspace_moving || -f /run/provisioning_script ]]; then
    kill -9 $(lsof -t -i:$LISTEN_PORT) > /dev/null 2>&1 &
    wait -n
    /usr/bin/python3 /opt/ai-dock/fastapi/logviewer/main.py \
        -p $LISTEN_PORT \
        -r 5 \
        -s "${SERVICE_NAME}" \
        -t "Preparing ${SERVICE_NAME}" &
    fastapi_pid=$!
    
    while [[ -f /run/workspace_moving || -f /run/provisioning_script ]]; do
        sleep 1
    done
    
    printf "\nStarting %s... " ${SERVICE_NAME:-service}
    kill $fastapi_pid &
    wait -n
    printf "OK\n"
else
    printf "Starting %s...\n" ${SERVICE_NAME}
fi

kill -9 $(lsof -t -i:$LISTEN_PORT) > /dev/null 2>&1 &
wait -n

cd /opt/stable-diffusion-webui

micromamba run -n webui python launch.py \
    ${PLATFORM_FLAGS} \
    ${BASE_FLAGS} \
    ${WEBUI_FLAGS}
