#!/usr/bin/env  bash

# look for files that end in .o or .tmp AND that are more than five days old
find ~ -atime +5 \( -name "*.o" -o -name "*.tmp" \)

# parentheses are quoted with backslashes so the shell doesn't treat the parentheses as subshell operators
# You need spaces before and after operators like !, (, ), and {}, in addition to spaces before and after every other operator. This is because find is relying on the shell to separate the command line into meaningful chunks, or tokens. And the shell, in turn, is assuming that tokens are separated by spaces.

# look for files that do not match these criteria
find ~ \! \( -atime +5 \( -name "*.o" -o -name "*.tmp" \) \)
