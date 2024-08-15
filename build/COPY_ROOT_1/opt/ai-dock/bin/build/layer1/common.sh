#!/bin/false

source /opt/ai-dock/etc/environment.sh

build_common_main() {
    # Nothing to do
    :
}

build_common_install_webui() {
    # Get latest tag from GitHub if not provided
    if [[ -z $WEBUI_BUILD_REF ]]; then
        export WEBUI_BUILD_REF="$(curl -s https://api.github.com/repos/AUTOMATIC1111/stable-diffusion-webui/tags | \
            jq -r '.[0].name')"
        env-store WEBUI_BUILD_REF
    fi

    cd /opt
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
    cd /opt/stable-diffusion-webui
    git checkout "$WEBUI_BUILD_REF"
    
    "$WEBUI_VENV_PIP" install --no-cache-dir -r requirements_versions.txt
}

build_common_run_tests() {
    installed_pytorch_version=$("$WEBUI_VENV_PYTHON" -c "import torch; print(torch.__version__)")
    echo "Checking PyTorch version contains ${PYTORCH_VERSION}..."
    if [[ "$installed_pytorch_version" != "$PYTORCH_VERSION"* ]]; then
        echo "Expected PyTorch ${PYTORCH_VERSION} but found ${installed_pytorch_version}\n"
        exit 1
    fi
    echo "Found PyTorch ${PYTORCH_VERSION}. Success!"
}

build_common_main "$@"