#!/bin/bash
set -e

if [ "$1" = 'bash' ]; then
	exec bash --login
else
	exec $@
fi
