#!/bin/false
# This file will be sourced in init.sh

function preflight_main() {
    preflight_copy_notebook
    preflight_update_webui
    printf "%s" "${WEBUI_FLAGS}" > /etc/a1111_webui_flags.conf
}

function preflight_copy_notebook() {
    if micromamba env list | grep 'jupyter' > /dev/null 2>&1;  then
        if [[ ! -f "${WORKSPACE}webui.ipynb" ]]; then
            cp /usr/local/share/ai-dock/webui.ipynb ${WORKSPACE}
        fi
    fi
}

function preflight_update_webui() {
    if [[ ${AUTO_UPDATE,,} != "false" ]]; then
        /opt/ai-dock/bin/update-webui.sh
    else
        printf "Skipping auto update (AUTO_UPDATE=false)"
    fi
}

preflight_main "$@"