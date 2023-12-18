#!/bin/false

build_nvidia_main() {
    build_nvidia_install_webui
}

build_nvidia_install_webui() {
    micromamba run -n webui ${PIP_INSTALL} \
        torch=="${PYTORCH_VERSION}" \
        nvidia-ml-py3
        
    micromamba install -n webui -c xformers xformers

    /opt/ai-dock/bin/update-webui.sh
}

build_nvidia_main "$@"