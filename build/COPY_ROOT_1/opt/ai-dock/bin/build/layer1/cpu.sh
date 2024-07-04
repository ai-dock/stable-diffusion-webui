#!/bin/false

build_cpu_main() {
    build_cpu_install_webui
    build_common_run_tests
}

build_cpu_install_webui() {
    build_common_install_webui
}

build_cpu_main "$@"