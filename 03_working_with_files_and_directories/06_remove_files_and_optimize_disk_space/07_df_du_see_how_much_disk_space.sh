#!/usr/bin/env bash

# For each filesystem, df tells you the capacity, how much space is in use, and how much is free.
df
# display disk size in human readable
df -h
# display specified filesystem
df -h .
df -h /dev/loop0
# If you are interested in inode usage
df -i .

# du shows how much storage a specific directory requires
du
# -k report in kilobytes
du -k
# -s only list total storage, do not include subdirectories
du -s $HOME/Dropbox
# to show size of all files and directory but not subdirectories:
du -s $HOME/*
