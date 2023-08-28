#!/bin/bash

# Must exit and fail to build if any command fails
set -e

main() {
    install_webui
}

install_webui() {
    micromamba run -n webui ${PIP_INSTALL} \
        torch=="${PYTORCH_VERSION}" \
        xformers \
        nvidia-ml-py3

    /opt/ai-dock/bin/update-webui.sh
}

main "$@"; exit