#!/bin/false

build_nvidia_main() {
    build_nvidia_install_webui
    build_common_run_tests
    build_nvidia_run_tests
}

build_nvidia_install_webui() {
    build_common_install_webui
}

build_nvidia_run_tests() {
    installed_pytorch_cuda_version=$("$WEBUI_VENV_PYTHON" -c "import torch; print(torch.version.cuda)")
    echo "Checking CUDA version contains ${CUDA_VERSION}..."
    if [[ "$CUDA_VERSION" != "$installed_pytorch_cuda"* ]]; then
        echo "Expected PyTorch CUDA ${CUDA_VERSION} but found ${installed_pytorch_cuda}\n"
        exit 1
    fi
    echo "Found CUDA ${CUDA_VERSION}. Success!"
}

build_nvidia_main "$@"