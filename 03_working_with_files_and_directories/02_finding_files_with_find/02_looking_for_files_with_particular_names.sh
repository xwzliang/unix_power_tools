#!/usr/bin/env  bash

# Because the shell also interprets wildcards, it is necessary to quote them so they are passed to find unchanged. Any kind of quoting can be used: 
find ~ -name \*.sh -print
find ~ -name '*.sh' -print
find ~ -name "[a-zA-Z]*.sh" -print
