#!/usr/bin/env bats

@test "look" {
	rm -rf tmp
	mkdir tmp
	cd tmp
	ls /bin > list_bin

	# Use look to display lines beginning with a given string
	# usage: look [-bdf] [-t char] string [file ...]
	expect=$(cat <<- _EOF_
	bzcat
	bzcmp
	bzdiff
	bzegrep
	bzexe
	bzfgrep
	bzgrep
	bzip2
	bzip2recover
	bzless
	bzmore
	_EOF_
	)
	run look bz list_bin
	[ "$output" == "$expect" ]
}
