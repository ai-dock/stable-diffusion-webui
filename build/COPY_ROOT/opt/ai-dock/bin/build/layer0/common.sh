#!/bin/false

source /opt/ai-dock/etc/environment.sh
webui_git="https://github.com/AUTOMATIC1111/stable-diffusion-webui"

build_common_main() {
    build_common_create_env
    build_common_install_jupyter_kernels
    build_common_clone_webui
}

build_common_create_env() {
    apt-get update
    $APT_INSTALL libgl1 libgoogle-perftools4
    ln -sf $(ldconfig -p | grep -Po "libtcmalloc.so.\d" | head -n 1) \
        /lib/x86_64-linux-gnu/libtcmalloc.so
    # A new pytorch env costs ~ 300Mb
    exported_env=/tmp/${MAMBA_DEFAULT_ENV}.yaml
    micromamba env export -n ${MAMBA_DEFAULT_ENV} > "${exported_env}"
    $MAMBA_CREATE -n webui --file "${exported_env}"
    $MAMBA_INSTALL -n webui \
        httpx=0.24.1
}

build_common_install_jupyter_kernels() {
    if [[ $IMAGE_BASE =~ "jupyter-pytorch" ]]; then
        $MAMBA_INSTALL -n webui \
            ipykernel \
            ipywidgets
        
        kernel_path=/usr/local/share/jupyter/kernels
        
        # Add the often-present "Python3 (ipykernel) as a comfyui alias"
        rm -rf ${kernel_path}/python3
        dir="${kernel_path}/python3"
        file="${dir}/kernel.json"
        cp -rf ${kernel_path}/../_template ${dir}
        sed -i 's/DISPLAY_NAME/'"Python3 (ipykernel)"'/g' ${file}
        sed -i 's/PYTHON_MAMBA_NAME/'"webui"'/g' ${file}
        
        dir="${kernel_path}/webui"
        file="${dir}/kernel.json"
        cp -rf ${kernel_path}/../_template ${dir}
        sed -i 's/DISPLAY_NAME/'"WebUI"'/g' ${file}
        sed -i 's/PYTHON_MAMBA_NAME/'"webui"'/g' ${file}
    fi
}

build_common_clone_webui() {
    cd /opt
    git clone ${webui_git}
}

build_common_main "$@"