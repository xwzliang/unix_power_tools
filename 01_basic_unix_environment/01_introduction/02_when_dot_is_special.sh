# Unlike other OS, Unix treats a dot '.' not a special character within a filename. So "rm *" is very dangerous as it will delete almost all the files.

# But there is an exception: shells and ls command consider a . special if it is the first character of a filename.

# So this will not include directories started with .
echo $(ls ~/*)

# This will include only directories started with .
echo $(ls ~/.*)
