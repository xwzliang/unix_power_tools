#!/usr/bin/env  bash

# Search by type: d -- directory, f -- file, l -- symbolic link

find . -type f | xargs ls -l
# find all the symbolic links in your home directory and print the files to which your symbolic links point. $NF gives the last field of each line, which holds the name to which a symlink points. If your find doesn't have a -ls operator, pipe to xargs ls -l as previously.
find $HOME -type l -ls | awk '{print $NF}'


# Search by size: The number after this argument is the size of the files in disk blocks. Unfortunately, this is a vague number.  Earlier versions of Unix used disk blocks of 512 bytes. Newer versions allow larger block sizes, so a "block" of 512 bytes is misleading.
# You can put a c after the number and specify the size in bytes. To find a file with exactly 1,234 bytes (as in an ls -l listing), type:
find . -size 1234c
# size range:
find . -size +10000c -size -32000c


# Seach by permission: 
find . -name \*.o -perm 664
# The previous examples only match an exact combination of permissions. If you wanted to find all directories with group write permission, you want to match the pattern ----w----. There are several combinations that can match. You could list each combination, but find allows you to specify a pattern that can be bitwise ANDed with the permissions of the file. Simply put a minus sign (-) before the octal value. The group write permission bit is octal 20, so the following negative value -20 will match all with group write permission.
find . -perm -20
# If you wanted to look for files that the owner can execute (i.e., shell scripts or programs), you want to match the pattern --x------ by typing:
find . -perm -100


# Search by owner and group
# To find all files that are set user ID (setuid) root, use this:
find . -user root -perm -4000
# To find all files that are set group ID (setgid) staff, use this:
find . -group staff -perm -2000
# Instead of using a name or group from /etc/passwd or /etc/group, you can use the UID or GID number:
find . -user 0 -perm -4000
find . -group 10 -perm -2000
