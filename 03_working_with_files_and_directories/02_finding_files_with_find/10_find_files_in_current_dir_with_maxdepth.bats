#!/usr/bin/env  bats

@test "find in current dir with maxdepth" {
	mkdir -p tmp
	rm -r tmp
	mkdir tmp
	cd tmp
	touch file1
	# touch -t specifies a particular time using this format: [[[[cc]yy]MM]dd]hhmm[.ss]
	touch -t 201909011000 file2

	run find . -type f -mtime -1
	expect=$(cat <<- _EOF_
	./file1
	_EOF_
	)
	[ "$output" == "$expect" ]

	mkdir adir
	touch adir/file3

	run find . -type f -mtime -1
	expect=$(cat <<- _EOF_
	./adir/file3
	./file1
	_EOF_
	)
	[ "$output" == "$expect" ]

	# Use -maxdepth 1 to search files only in current directory
	run find . -maxdepth 1 -type f -mtime -1
	expect=$(cat <<- _EOF_
	./file1
	_EOF_
	)
	[ "$output" == "$expect" ]
}
