#!/usr/bin/env  bats

@test "find hard links" {
	run ls -li /usr/bin/python3.6
	[ "$output" == "2758306 -rwxr-xr-x 2 root root 4571576 Jan 14  2019 /usr/bin/python3.6" ]
	inode_num=`ls -li /usr/bin/python3.6 | awk '{print $1}'`
	[ $inode_num == 2758306 ]
	# hard links have the same inode number, but inode numbers are only unique to a given filesystem
	# -xdev tells find to only search current filesystem
	run find /usr -xdev -inum $inode_num
	[ "$output" == "`echo -e '/usr/bin/python3.6m\n/usr/bin/python3.6'`" ]
}
