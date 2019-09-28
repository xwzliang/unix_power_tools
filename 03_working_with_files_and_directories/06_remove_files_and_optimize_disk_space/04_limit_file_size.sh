#!/usr/bin/env bash

# the following ksh command keep you from creating any files larger than 2 MB:
ulimit -f 2000

# To set a maximum size for core dumps
ulimit -c 2000
