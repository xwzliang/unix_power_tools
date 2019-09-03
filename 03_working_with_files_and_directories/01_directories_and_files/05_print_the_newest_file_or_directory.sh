#!/usr/bin/env  bash

# Print the name of the newest file or directory
# example newest *.sh, will print the newest sh file
# This function can be placed at bashrc as an command

newest() { ls -dt "$@" | head -1; }

newest "$@"
