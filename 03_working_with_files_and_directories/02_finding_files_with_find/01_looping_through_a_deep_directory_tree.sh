#!/usr/bin/env  bash

# find path(s) -print will print all files
# Most mordern versions of find will assume -print as default, so you can omit it
find . -print

find ~ /usr/local/bin 

ls -ld `find ~ -print`
# The above backquoted command might generate an error when the command line is too large, the equivalent command using xargs will never generate that error. Because xargs knows the the maximum number of arguments each command line can handle and does not exceed that limit.
find ~ -print | xargs ls -ld
