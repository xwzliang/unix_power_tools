#!/usr/bin/env bats

@test "paste" {
	# paste: paste contents from different files side by side

	test_string=$(cat <<- _EOF_
	SUSE	10.2	12/07/2006
	Fedora	10	11/25/2008
	SUSE	11.0	06/19/2008
	Ubuntu	8.04	04/24/2008
	_EOF_
	)

	run cut -f 3,1 <<< $test_string
	expect=$(cat <<- _EOF_
	SUSE	12/07/2006
	Fedora	11/25/2008
	SUSE	06/19/2008
	Ubuntu	04/24/2008
	_EOF_
	)
	# cut will not change the order of columns even if the field numbers are specified as a different order
	[ "$output" == "$expect" ]

	# Use paste can change the order
	run paste <(cut -f 3 <<< $test_string) <(cut -f 1 <<< $test_string)
	expect=$(cat <<- _EOF_
	12/07/2006	SUSE
	11/25/2008	Fedora
	06/19/2008	SUSE
	04/24/2008	Ubuntu
	_EOF_
	)
	[ "$output" == "$expect" ]


	# The separate data streams being merged are separated by default with a tab, but you can change this with the -d option.
	run paste -d - <(cut -f 3 <<< $test_string) <(cut -f 1 <<< $test_string)
	expect=$(cat <<- _EOF_
	12/07/2006-SUSE
	11/25/2008-Fedora
	06/19/2008-SUSE
	04/24/2008-Ubuntu
	_EOF_
	)
	[ "$output" == "$expect" ]

	# Unlike the -d option to cut, you need not specify a single character; instead, you can specify a list of characters, which will be used in a circular fashion.
	run paste -d "-," <(cut -f 3 <<< $test_string) <(cut -f 1 <<< $test_string) <(cut -f 2 <<< $test_string)
	expect=$(cat <<- _EOF_
	12/07/2006-SUSE,10.2
	11/25/2008-Fedora,10
	06/19/2008-SUSE,11.0
	04/24/2008-Ubuntu,8.04
	_EOF_
	)
	[ "$output" == "$expect" ]


	# -s (--serial) option that lets you merge subsequent lines from one file (paste one file at a time instead of in parallel)
	run paste -sd "-," <(cut -f 3 <<< $test_string) <(cut -f 1 <<< $test_string) <(cut -f 2 <<< $test_string)
	expect=$(cat <<- _EOF_
	12/07/2006-11/25/2008,06/19/2008-04/24/2008
	SUSE-Fedora,SUSE-Ubuntu
	10.2-10,11.0-8.04
	_EOF_
	)
	[ "$output" == "$expect" ]

	# Use -s and -d with one of the two delimiters being "\n" ("-\n") will merge each pair of lines onto a single line
	run paste -s -d "-\n" <(cut -f 3 <<< $test_string)
	expect=$(cat <<- _EOF_
	12/07/2006-11/25/2008
	06/19/2008-04/24/2008
	_EOF_
	)
	[ "$output" == "$expect" ]


	# To make paste read standard input, use the - option, and repeat - for every column you want. Every line of stdin becomes a column item.
	output=$(echo {a..i} | tr ' ' '\n' | paste - - -)
	expect=$(cat <<- _EOF_
	a	b	c
	d	e	f
	g	h	i
	_EOF_
	)
	[ "$output" == "$expect" ]
}
