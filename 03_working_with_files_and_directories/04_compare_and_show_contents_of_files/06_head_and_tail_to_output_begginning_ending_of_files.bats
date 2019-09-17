#!/usr/bin/env bats

@test "head and tail" {
	# Use head to output begginning of a file, default is 10 lines
	input=$(seq 1 100 | tr " " "\n")
	expect=$(seq 1 10 | tr " " "\n")
	output=$(head <<< "$input")
	[ "$output" == "$expect" ]

	# Use head -num(-n num) to specify the number of output lines
	expect=$(seq 1 5 | tr " " "\n")
	output=$(head -5 <<< "$input")
	[ "$output" == "$expect" ]

	# Use tail to output ending of a file, default is 10 lines
	input=$(seq 1 100 | tr " " "\n")
	expect=$(seq 91 100 | tr " " "\n")
	output=$(tail <<< "$input")
	[ "$output" == "$expect" ]

	# Use tail -num(-n num) to specify the number of output lines
	expect=$(seq 96 100 | tr " " "\n")
	output=$(tail -5 <<< "$input")
	[ "$output" == "$expect" ]

	# For both head and tail, -c option will specify number of bytes instead of lines

	# Use tail -f to monitor files that are constantly renewed(like logs)
	# The command below will monitor two files simultaneously: syslog and syslog.1
	# Which file changed, the new text appeared following a line specifying which file (==> /var/log/syslog.1 <==)
	# tail -f /var/log/syslog{,.1}

	# By default, tail opens a file for reading and gets a file descriptor number, which it constantly watches for changes. 
	# Use tail --follow=name --retry (or tail -F) to reopen file automatically if the file is renamed and a new file with the old name (and a new inode) takes its place
	# tail --follow=name --retry /var/log/syslog{,.1}
}
