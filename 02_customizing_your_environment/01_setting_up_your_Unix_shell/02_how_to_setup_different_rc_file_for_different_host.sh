#!/usr/bin/env bash

# uname -n will give host name
HOST="`uname -n`"

if [ -e ~/lib/cshrc.hosts/cshrc.$HOST ]; then
	source ~/lib/cshrc.hosts/cshrc.$HOST
fi
