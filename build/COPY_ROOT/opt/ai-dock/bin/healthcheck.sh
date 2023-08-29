#!/bin/bash

curl --fail localhost:7860 > /dev/null 2>&1
webui_status=$?
if [[ $webui_status -gt 0 ]]; then
    exit 1
fi

exit 0
