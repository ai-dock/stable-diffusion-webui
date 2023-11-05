#!/bin/bash

echo "$@" > /etc/a1111_webui_flags.conf
supervisorctl restart webui