#!/bin/false

build_cpu_main() {
    build_cpu_install_webui
}

build_cpu_install_webui() {
    /opt/ai-dock/bin/update-webui.sh
}

build_cpu_main "$@"