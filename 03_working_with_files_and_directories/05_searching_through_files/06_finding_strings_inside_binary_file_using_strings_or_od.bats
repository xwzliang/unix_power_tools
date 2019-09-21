#!/usr/bin/env bats

@test "strings and od" {
	# Use strings to output strings of printable characters in files
	expect=$(cat <<- _EOF_
	/lib64/ld-linux-x86-64.so.2
	libbsd.so.0
	_ITM_deregisterTMCloneTable
	__gmon_start__
	_ITM_registerTMCloneTable
	strlcpy
	libc.so.6
	putwchar
	__printf_chk
	exit
	_EOF_
	)
	output=$(strings /usr/bin/write | head -10)
	[ "$output" == "$expect" ]
	# strings will output strings that are more than 4 characters by default, this can be specified by -num option
	expect=$(cat <<- _EOF_
	/lib64/ld-linux-x86-64.so.2
	_ITM_deregisterTMCloneTable
	_ITM_registerTMCloneTable
	usage: write user [tty]
	%s has messages disabled
	can't find your tty's name
	%s is not logged in on %s
	%s is logged in more than once; writing to %s
	Message from %s@%s on %s at %s ...
	write: you have write permission turned off.
	_EOF_
	)
	output=$(strings -20 /usr/bin/write | head -10)
	[ "$output" == "$expect" ]

	# The od command with its option -s n command does a similar thing: finds all null-terminated strings that are at least n characters long.
	expect=$(cat <<- _EOF_
	0001070 /lib64/ld-linux-x86-64.so.2
	0003565 _ITM_deregisterTMCloneTable
	0003640 _ITM_registerTMCloneTable
	0015701 %s has messages disabled
	0015762 can't find your tty's name
	_EOF_
	)
	output=$(od -S 20 /usr/bin/write | head -5)
	[ "$output" == "$expect" ]
}
