#!/usr/bin/env bats

@test "uniq" {
	# uniq reads a file and compares adjacent lines (which means you'll usually want to sort the file first to be sure identical lines appear next to each other)

	test_string=$(cat <<- _EOF_
	a
	a
	A
	b
	c
	c
	_EOF_
	)

	# By default, only the first occurrence of a line is written to the output
	run uniq <<< $test_string
	expect=$(cat <<- _EOF_
	a
	A
	b
	c
	_EOF_
	)
	[ "$output" == "$expect" ]

	# With the -u option, the output gets only the lines that occur just once (and weren't repeated)
	run uniq -u <<< $test_string
	expect=$(cat <<- _EOF_
	A
	b
	_EOF_
	)
	[ "$output" == "$expect" ]

	# The -d option does the opposite: the output gets a single copy of each line that was repeated (no matter how many times it was repeated)
	run uniq -d <<< $test_string
	expect=$(cat <<- _EOF_
	a
	c
	_EOF_
	)
	[ "$output" == "$expect" ]

	# -D option (GNU). It's like -d except that all duplicate lines are output
	run uniq -D <<< $test_string
	expect=$(cat <<- _EOF_
	a
	a
	c
	c
	_EOF_
	)
	[ "$output" == "$expect" ]

	# The output with -c is like the default, but each line is preceded by a count of how many times it occurred.
	run uniq -c <<< $test_string
	expect=$(cat <<- _EOF_
	      2 a
	      1 A
	      1 b
	      2 c
	_EOF_
	)
	# There are six spaces at the beginning of each line
	[ "$output" == "$expect" ]

	# GNU uniq also has -i to make comparisons case-insensitive. (Upper- and lowercase letters compare equal.)
	run uniq -i <<< $test_string
	expect=$(cat <<- _EOF_
	a
	b
	c
	_EOF_
	)
	[ "$output" == "$expect" ]


	test_string=$(cat <<- _EOF_
	a a test
	b b test
	c c test
	d d test d
	_EOF_
	)

	# -n ignores the first n fields of a line and all whitespace before each. A field is defined as a string of nonwhitespace characters (separated from its neighbors by whitespace).
	run uniq -2 <<< $test_string
	expect=$(cat <<- _EOF_
	a a test
	d d test d
	_EOF_
	)
	[ "$output" == "$expect" ]

	# +n ignores the first n characters. Fields are skipped before characters.
	run uniq -1 <<< $test_string
	[ "$output" == "$test_string" ]
	run uniq -1 +2 <<< $test_string
	expect=$(cat <<- _EOF_
	a a test
	d d test d
	_EOF_
	)
	[ "$output" == "$expect" ]

	# -w n in the GNU version compares no more than n characters in each line.
	run uniq -1 +2 -w 4 <<< $test_string
	expect=$(cat <<- _EOF_
	a a test
	_EOF_
	)
	[ "$output" == "$expect" ]
}
