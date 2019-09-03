#!/usr/bin/env  bash

# usage: count_types [directory ...]
# Counts how many files there are of each type
# Original by Bruce Barnett
# Updated version by yu@math.duke.edu (Yunliang Yu)

find "$@" -type f -print | xargs file |
awk '{
	$1=NULL;
	t[$0]++;
}
END {
	for (i in t) printf("%d\t%s\n", t[i], i);
}' | sort -nr	# Sort the result numerically, in reverse
