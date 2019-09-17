#!/usr/bin/env bats

@test "cat -s -n" {
	input=$(cat <<- _EOF_
	one
	two


	five
	_EOF_
	)
	# Use cat -s to squash extra blank lines (replace multiple blank lines with a single blank line)
	expect=$(cat <<- _EOF_
	one
	two

	five
	_EOF_
	)
	output=$(cat -s <<<"$input")
	[ "$output" == "$expect" ]

	# Use cat -n to output with line numbers
	# line numbers are right-justified at column 6, and has a tab after them
	expect=$(cat << _EOF_
     1	one
     2	two
     3	
     4	
     5	five
_EOF_
)
	output=$(cat -n <<<"$input")
	[ "$output" == "$expect" ]

	# Use nl can also output line numbers, nl -ba will output the same as cat -n
	output=$(nl -ba <<<"$input")
	[ "$output" == "$expect" ]
}
