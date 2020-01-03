#!/usr/bin/env bats

@test "sort alphabetic numeric difference" {

	test_string=$(cat <<- _EOF_
	12
	1
	11
	2
	21
	_EOF_
	)

	# alphabetic sort
	run sort <<< $test_string
	expect=$(cat <<- _EOF_
	1
	11
	12
	2
	21
	_EOF_
	)
	[ "$output" == "$expect" ]

	# numeric sort
	run sort -n <<< $test_string
	expect=$(cat <<- _EOF_
	1
	2
	11
	12
	21
	_EOF_
	)
	[ "$output" == "$expect" ]
}
