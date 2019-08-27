#!/usr/bin/env bash

flags=$(echo $-)

# Running from script flags will not be the same as running from interactive shell
echo "Flags of shell are $flags"

if [[ $flags =~ h ]]; then echo "-h Remember the location of commands as they are looked up."; fi
if [[ $flags =~ i ]]; then echo "-i shell is interactive"; fi
if [[ $flags =~ m ]]; then echo "-m monitor mode, job control is enabled"; fi
if [[ $flags =~ B ]]; then echo "-B the shell will perform brace expansion"; fi
if [[ $flags =~ H ]]; then echo "-H Enable ! style history substitution.  This flag is on by default when the shell is interactive."; fi
if [[ $flags =~ s ]]; then echo "-s shell is reading from standard input"; fi

