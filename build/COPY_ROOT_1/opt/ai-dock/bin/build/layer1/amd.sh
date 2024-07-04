#!/bin/false

build_amd_main() {
    build_amd_install_bitsandbytes
    build_amd_install_webui
    build_common_run_tests
}

build_amd_install_bitsandbytes() {
    # TODO - This really needs moving to a separate, external build step
    # https://github.com/ROCm/bitsandbytes
    DEV_PACKAGES="rocm-dev hipblas-dev hipblaslt-dev hipcub-dev hiprand-dev hipsparse-dev rocblas-dev rocthrust-dev"
    if [[ $ROCM_LEVEL != "devel" ]]; then
        $APT_INSTALL $DEV_PACKAGES
    fi
    cd /tmp
    git clone --recurse https://github.com/ROCm/bitsandbytes
    cd bitsandbytes
    git checkout rocm_enabled
    "$WEBUI_VENV_PIP" install --no-cache-dir -r requirements-dev.txt
    cmake -DCOMPUTE_BACKEND=hip -S . #Use -DBNB_ROCM_ARCH="gfx90a;gfx942" to target specific gpu arch
    make
    "$WEBUI_VENV_PIP" install --no-cache-dir .
    cd /tmp
    rm -rf /tmp/bitsandbytes
    if [[ $ROCM_LEVEL != "devel" ]]; then
        apt-get remove -y $DEV_PACKAGES
        apt-get autoremove -y
    fi
}

build_amd_install_webui() {
    build_common_install_webui
}

build_amd_main "$@"