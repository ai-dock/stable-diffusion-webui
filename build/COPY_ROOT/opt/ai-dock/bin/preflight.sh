#!/bin/false

# This file will be sourced in init.sh

function preflight_main() {
    preflight_copy_notebook
    preflight_update_webui
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