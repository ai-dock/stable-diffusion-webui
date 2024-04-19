#!/bin/false

build_amd_main() {
    build_amd_install_webui
    build_common_run_tests
}

build_amd_install_webui() {
  build_common_install_webui
}

build_amd_main "$@"