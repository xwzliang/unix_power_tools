#!/usr/bin/env  bash

# If you want to find a file that is seven days old, use the -mtime operator:
find ~ -mtime 7

# To specify a range of times:
find ~ -mtime +6 -mtime -8

# If you want to look for files that have not been used, check the access time with the -atime argument. Here is a command to list all files that have not been read in 30 days or more:
find ~ -type f -atime +30 -print

# There is another time associated with each file, called the ctime, the inode change time. Access it with the -ctime operator. The ctime will have a more recent value if the owner, group, permission, or number of links has changed, while the file itself has not. If you want to search for files with a specific number of links, use the -links operator.

# The times in find are in days:
# A number with no sign, for example, 3 (as in -mtime 3 or -atime 3), means the 24-hour period that ended exactly 3 days ago (in other words, between 96 and 72 hours ago).
# A number with a minus sign (-) refers to the period since that 24-hour period. For example, -3 (as in -mtime -3) is any time between now and 3 days ago (in other words, between 0 and 72 hours ago).
# Naturally, a number with a plus sign (+) refers to the period before that 24-hour period. For example, +3 (as in -mtime +3) is any time more than 3 days ago (in other words, more than 96 hours ago).

# If you want the time more acurate than days, you can use find -mmin -cmin and -amin, which specify time in minutes
