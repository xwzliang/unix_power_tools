#!/usr/bin/env  bash

# usage: age_files [directory ...]
# lists size of files by age
#
# pick which version of ls you use
#   System V
LS="ls -ls"
#   Berkeley
#LS="ls -lsg"
#
find "$@" -type f -print | xargs $LS | awk '
# argument 7 is the month; argument 9 is either hh:mm or yyyy
# test if argument is hh:mm or yyyy format
{
	if ($9 !~ /:/) {
		sz[$9]+=$1;
	} else {
		sz[$7]+=$1;
	}
}
END {
	for (i in sz) printf("%d\t%s\n", sz[i], i);
}' | sort -nr
