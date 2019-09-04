#!/usr/bin/env  bash

# $$ returns shell's process ID number. Use the date's + option to output the Year, month, day, Hour, Minute, and Second
output=/tmp/myprog$$.`date +'%Y%m%d%H%M%S'`
echo $output
