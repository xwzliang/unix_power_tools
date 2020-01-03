#!/usr/bin/env bats

@test "sort lines by length" {

	test_string=$(cat <<- _EOF_
	text text text text text text
	text text text
	text text text text
	text text text text text text text text text text text text text text text text text text
	_EOF_
	)

	output=$(awk '{ print length(), $0 }'<<< $test_string |
	# Sort the lines numerically by first field
	sort +0n -1 |
	# Remove the length and the space
	sed 's/^[0-9][0-9]* //'
	)

	expect=$(cat <<- _EOF_
	text text text
	text text text text
	text text text text text text
	text text text text text text text text text text text text text text text text text text
	_EOF_
	)
	[ "$output" == "$expect" ]
}
