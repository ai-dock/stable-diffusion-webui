#!/bin/false

# This file will be sourced in init.sh

function preflight_main() {
    preflight_move_to_workspace
    preflight_copy_notebook
    preflight_update_webui
}

function preflight_move_to_workspace() {
    if [[ ! -e ${WORKSPACE}stable-diffusion-webui && $WORKSPACE_MOUNTED = "true" ]]; then
        mv /opt/stable-diffusion-webui ${WORKSPACE}
        ln -s ${WORKSPACE}stable-diffusion-webui /opt/stable-diffusion-webui
    elif [[ -d ${WORKSPACE}stable-diffusion-webui && $WORKSPACE_MOUNTED = "true" ]]; then
        rm -rf /opt/stable-diffusion-webui
        ln -s ${WORKSPACE}stable-diffusion-webui /opt/stable-diffusion-webui
    elif [[ $WORKSPACE_MOUNTED = "false" && -d /opt/stable-diffusion-webui ]]; then
        ln -s /opt/stable-diffusion-webui ${WORKSPACE}webui
    fi
}

function preflight_copy_notebook() {
    if micromamba env list | grep 'jupyter' > /dev/null 2>&1;  then
        if [[ ! -f "${WORKSPACE}webui.ipynb" ]]; then
            cp /usr/local/share/ai-dock/webui.ipynb ${WORKSPACE}
        fi
    fi
}

function preflight_update_webui() {
    /opt/ai-dock/bin/update-webui.sh
}

preflight_main "$@"