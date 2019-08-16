# man -k option searches database files for matches of a given keyword, returning the results. This is particularly helpful in finding commands that contain a specific keyword if you're not quite sure what the command is.

keyword=$1

man -k $keyword

# Example
# Output of "man -k egrep"
#bzegrep (1)          - search possibly bzip2 compressed files for a regu...
#egrep (1)            - print lines matching a pattern
#lzegrep (1)          - search compressed files for a regular expression
#xzegrep (1)          - search compressed files for a regular expression
#zegrep (1)           - search possibly compressed files for a regular ex...
