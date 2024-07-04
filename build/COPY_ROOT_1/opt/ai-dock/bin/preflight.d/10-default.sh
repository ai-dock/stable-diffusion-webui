#!/bin/false
# This file will be sourced in init.sh

function preflight_main() {
    preflight_update_webui
    printf "%s" "${WEBUI_FLAGS}" > /etc/a1111_webui_flags.conf
}

function preflight_update_webui() {
    if [[ ${AUTO_UPDATE,,} == "true" ]]; then
        /opt/ai-dock/bin/update-webui.sh
    else
        printf "Skipping auto update (AUTO_UPDATE != true)"
    fi
}

preflight_main "$@"