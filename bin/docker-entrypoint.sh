#!/bin/bash
set -x

USER=axerunner

chown -R ${USER} .
cron && exec gosu ${USER} "$@"
