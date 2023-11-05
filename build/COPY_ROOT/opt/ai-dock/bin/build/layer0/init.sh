#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail

/opt/ai-dock/bin/build/layer0/common.sh

if [[ "$XPU_TARGET" == "NVIDIA_GPU" ]]; then
    /opt/ai-dock/bin/build/layer0/nvidia.sh
elif [[ "$XPU_TARGET" == "AMD_GPU" ]]; then
    /opt/ai-dock/bin/build/layer0/amd.sh
elif [[ "$XPU_TARGET" == "CPU" ]]; then
    /opt/ai-dock/bin/build/layer0/cpu.sh
else
    printf "No valid XPU_TARGET specified\n" >&2
    exit 1
fi

# webui 'prepare-environment'
cd /opt/stable-diffusion-webui
micromamba run -n webui python launch.py --skip-torch-cuda-test --skip-python-version-check --no-download-sd-model --do-not-download-clip --exit

/opt/ai-dock/bin/build/layer0/clean.sh