#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail

webui_git="https://github.com/AUTOMATIC1111/stable-diffusion-webui"

main() {
    create_env
    install_jupyter_kernels
    clone_webui
}

create_env() {
    apt-get update
    $APT_INSTALL libgl1
    # A new pytorch env costs ~ 300Mb
    exported_env=/tmp/${MAMBA_DEFAULT_ENV}.yaml
    micromamba env export -n ${MAMBA_DEFAULT_ENV} > "${exported_env}"
    $MAMBA_CREATE -n webui --file "${exported_env}"
}

install_jupyter_kernels() {
    if [[ $IMAGE_BASE =~ "jupyter-pytorch" ]]; then
        $MAMBA_INSTALL -n webui -c conda-forge -y \
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

clone_webui() {
    cd /opt
    git clone ${webui_git}
}

main "$@"; exit