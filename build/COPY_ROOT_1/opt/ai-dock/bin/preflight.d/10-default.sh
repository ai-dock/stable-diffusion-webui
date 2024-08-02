#!/bin/false
# This file will be sourced in init.sh

function preflight_main() {
    if [[ -n $WEBUI_FLAGS ]]; then
        export WEBUI_ARGS="$WEBUI_FLAGS"
        env-store WEBUI_ARGS
    fi
    preflight_update_webui
    printf "%s" "${WEBUI_ARGS}" > /etc/a1111_webui_args.conf
    ln -s /etc/a1111_webui_args.conf /etc/a1111_webui_flags.conf
}

function preflight_update_webui() {
    if [[ ${AUTO_UPDATE,,} == "true" ]]; then
        /opt/ai-dock/bin/update-webui.sh
    else
        printf "Skipping auto update (AUTO_UPDATE != true)"
    fi
}

preflight_main "$@"