#!/usr/bin/env bats

@test "sdiff cmp comm" {
	rm -rf tmp
	mkdir tmp
	cd tmp
	echo {b..h} | tr " " "\n" > file1
	echo {a..f} | tr " " "\n" > file2

	# Use sdiff to show side-by-side diff
	# sdiff's output contains tab and tabstop is 8, use cat -A to show them, and use expand -8 to convert tap to spaces
	# sdiff -w 10 file1 file2 | cat -A
	# sdiff -w 10 file1 file2 | expand -8
	# So this file also need to use vim to set tabstop=8 to see the actual proper formatted ouput
	expect=$(cat << _EOF_
    >	a
b	b
c	c
d	d
e	e
f	f
g   <
h   <
_EOF_
)
	# Use -w to choose number of columns for output
	run sdiff -w 10 file1 file2
	[ "$output" == "$expect" ]

	# Use expand to convert tabs before sending to diff
	# diff <(expand -4 file1) <(expand -4 file2)

	# Use simpler cmp to diff
	run cmp file1 file2
	[ "$output" == "file1 file2 differ: byte 1, line 1" ]


	# cmp and diff return 0 if files are the same, 1 if differ, 2 if error occurred, this is useful when used in shell script to know if two files are the same


	# Use comm to diff and show contents in common
	# Same as sdiff, comm output also uses tabs
	# First column is content unique in file1, second is unique in file2, third column is what two files are in common
	expect=$(cat << _EOF_
	a
		b
		c
		d
		e
		f
g
h
_EOF_
)
	run comm file1 file2
	[ "$output" == "$expect" ]
	# Use -1(2,3) options to suppress columns
	# To only show what is in common, use -12
	expect=$(cat << _EOF_
b
c
d
e
f
_EOF_
)
	run comm -12 file1 file2
	[ "$output" == "$expect" ]
}
