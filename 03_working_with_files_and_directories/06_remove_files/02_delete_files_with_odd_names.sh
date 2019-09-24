#!/usr/bin/env bash

# If file name has nonprintable characters, use ls -q to print question mark ?, use ls -b to print the octal value preceeded by a backslash

# Then you can using wildcards to delete files with strange names

# You can also use perl unlink to delete, say if a file is named "\t\360\207\005\254" (showed by ls -b)
perl -e 'unlink("\t\360\207\005\254");'

# You can also delete by its i-number using find (showed by ls -i)
find . -inum 6239 -exec rm {} \;

# If the name starts with a dash -, say a file "-f", using rm -f won't delete it, you can use following instead:
rm ./-f
