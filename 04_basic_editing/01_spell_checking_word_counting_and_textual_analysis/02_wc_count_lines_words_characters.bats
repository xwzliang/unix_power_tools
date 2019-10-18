#!/usr/bin/env bats

@test "test wc" {
	. mk_tmp_dir
	echo word{1..1000} > words.tmp

	# wc will return number of lines, words, characters by default
	run wc words.tmp
	# There are three leading spaces in the output
	expect="   1 1000 7893 words.tmp"
	[ "$output" == "$expect" ]

	# Options: -l (count lines only), -w (words only), -c (characters only)
	run wc -l words.tmp
	# There are no leading spaces in the output
	expect="1 words.tmp"
	[ "$output" == "$expect" ]
	run wc -w words.tmp
	expect="1000 words.tmp"
	[ "$output" == "$expect" ]
	run wc -c words.tmp
	expect="7893 words.tmp"
	[ "$output" == "$expect" ]
	# wc -c isn't an efficient way to count the characters in large numbers of files. wc opens and reads each file, which takes time. The fourth or fifth column of output from ls -l (depending on your version) gives the character count without opening the file.
	# Using character counts doesn't give you the total disk space used by files. That's because, in general, each file takes at least one disk block to store. The du command gives accurate disk usage.

	# If you don't want the filename at the end, use < to read the file
	run wc -w < words.tmp
	[ "$output" == 1000 ]
	# Don't use cat words.tmp | wc -w, it's less efficient.
	# As Tom Christiansen wrote in a Usenet article:
	# A wise man once said: if you find yourself calling cat with just one argument, then you're probably doing something you shouldn't.
	# The command line above only uses cat to feed the file to the standard input of wc. It's a lot more efficient to have the shell do the redirection for you with its < character

	# expr can evaluate expressions, the following calculate how many more words are in words.new.tmp than in words.tmp
	echo word{1..1200} > words.new.tmp
	run expr `wc -w < words.new.tmp` - `wc -w < words.tmp`
	[ "$output" == 200 ]
}
