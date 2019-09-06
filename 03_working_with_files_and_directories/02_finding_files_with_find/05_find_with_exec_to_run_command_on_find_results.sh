#!/usr/bin/env  bash

# -exec command must end with ;, and we need backslash or quotes to avoid shell using it.
# {} refers to the results find returns
find . -exec echo {} \;
find . -exec echo {} ';'

# -exec can also run find itself
# If you wanted to list every symbolic link in every directory owned by a group staff under the current directory, you could execute:
find `pwd` -type d -group staff -exec find {} -type l -print \;

# To search for all files with group-write permission under the current directory and to remove the permission, you can use:
find . -perm -20 -exec chmod g-w {} \;
find . -perm -20 -print | xargs chmod g-w
# The difference between -exec and xargs is subtle. The first one will execute the program once per file, while xargs can handle several files with each process. However, xargs may have problems with filenames that contain embedded spaces. (Versions of xargs that support the -0 option can avoid this problem; they expect NUL characters as delimiters instead of spaces, and find 's -print0 option generates output that way.)

# Occasionally, people create a strange file that they can't delete. This could be caused by accidentally creating a file with a space or some control character in the name. find and -exec can delete this file, while xargs could not. In this case, use ls -il to list the files and i-numbers, and use the -inum operator with -exec to delete the file:
find . -inum 31246 -exec rm {} ';'
# If you wish, you can use -ok , which does the same as -exec, except the program asks you to confirm the action first before executing the command.


# Remember that -exec doesn't necessarily evaluate to "true"; it only evaluates to true if the command it executes returns a zero exit status. You can use this to construct custom find tests. Assume that you want to list files that are "beautiful." You have written a program called beauty that returns zero if a file is beautiful and nonzero otherwise.
find . -exec beauty {} \;


# Use find 's -exec for large recursive greps. Let's say I want to search through a large directory with lots of subdirectories to find all of the .cc files that call the method GetRaw( ):
find . -name \*.cc -exec grep -n "GetRaw(" {} \;
# it shows me each line that matched my grep along with its line number, followed by the name of the file where those lines were found.
# Most versions of grep can search recursively (using -R), but they search all files; you need find to grep through only certain files in a large directory tree.


# Execute different command on different find results
find . \( -type d -a -exec chmod 771 {} \; \) -o \
	\( -name "*.BAK" -a -exec chmod 600 {} \; \) -o \
	\( -name "*.sh" -a -exec chmod 755 {} \; \) -o \
	\( -name "*.txt" -a -exec chmod 644 {} \; \)
# Running find is fairly time consuming, and for good reason: it has to read every inode in the directory tree that it's searching. Therefore, combine as many things as you can into a single find command. If you're going to walk the entire tree, you may as well accomplish as much as possible in the process.
