login_name=$1

cmd="grep $login_name /etc/passwd"

echo $($cmd)

# You should get back the contents of your entry in the system password file. For example:
# shelleyp:*:1006:1006:Shelley Powers:/usr/home/shelleyp:/usr/local/bin/bash
# The fields are separated by colons, and the default shell is usually specified in the last field.
