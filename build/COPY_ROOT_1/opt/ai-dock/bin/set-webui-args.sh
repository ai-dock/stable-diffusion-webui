#!/bin/bash

echo "$@" > /etc/a1111_webui_args.conf
supervisorctl restart webui