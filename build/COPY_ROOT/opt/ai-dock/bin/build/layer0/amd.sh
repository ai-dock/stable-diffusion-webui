#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail

main() {
    install_webui
}

install_webui() {
  # Mamba export does not include pip packages.
  # We need to get torch again - todo find a better way?
    micromamba -n webui run pip install \
        --no-cache-dir \
        --index-url https://download.pytorch.org/whl/rocm${ROCM_VERSION} \
        torch==${PYTORCH_VERSION} torchvision torchaudio
    /opt/ai-dock/bin/update-webui.sh
}

main "$@"; exit