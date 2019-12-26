#!/usr/bin/env bats

@test "cut" {
	# cut lets you select a list of characters or fields from one or more files.
	# You must specify either the -c option to cut by characters or -f to cut by fields. (Fields are separated by tabs unless you specify a different field separator with -d.)

	test_string=$(cat <<- _EOF_
	SUSE	10.2	12/07/2006
	Fedora	10	11/25/2008
	SUSE	11.0	06/19/2008
	Ubuntu	8.04	04/24/2008
	_EOF_
	)

	run cut -f 3 <<< $test_string
	expect=$(cat <<- '_EOF_'
	12/07/2006
	11/25/2008
	06/19/2008
	04/24/2008
	_EOF_
	)
	[ "$output" == "$expect" ]

	# You can specify filename for cut, below "-" indicates stdin (can be omitted)
	run cut -f 3 - <<< $test_string
	[ "$output" == "$expect" ]

	# -f and -c accept multiple numbers, comma separated for multiples, hyphen separated for range
	run cut -f 1,3 <<< $test_string
	expect=$(cat <<- '_EOF_'
	SUSE	12/07/2006
	Fedora	11/25/2008
	SUSE	06/19/2008
	Ubuntu	04/24/2008
	_EOF_
	)
	[ "$output" == "$expect" ]

	output=$(cut -f 3 <<< $test_string | cut -c 7-10)
	expect=$(cat <<- '_EOF_'
	2006
	2008
	2008
	2008
	_EOF_
	)
	[ "$output" == "$expect" ]

	# n- Omitting the number after the hyphen indicates the range is n to the end of line
	output=$(cut -f 3 <<< $test_string | cut -c 7-)
	[ "$output" == "$expect" ]

	output=$(cut -f 3 <<< $test_string | cut -d '/' -f 1,3)
	expect=$(cat <<- '_EOF_'
	12/2006
	11/2008
	06/2008
	04/2008
	_EOF_
	)
	[ "$output" == "$expect" ]
}
