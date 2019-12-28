#!/usr/bin/env bats

@test "join" {
	# join FILE1 FILE2: joins data from two files based on a shared key field. 

	test_string1=$(cat <<- _EOF_
	SUSE	10.2
	Fedora	10
	SUSE	11.0
	Ubuntu	8.04
	_EOF_
	)
	test_string2=$(cat <<- _EOF_
	SUSE	12/07/2006
	Fedora	11/25/2008
	SUSE	06/19/2008
	Ubuntu	04/24/2008
	_EOF_
	)


	# The default join field is the first. Default output field separator is a space.
	run join <(echo "$test_string1") <(echo "$test_string2")
	expect=$(cat <<- _EOF_
	SUSE 10.2 12/07/2006
	Fedora 10 11/25/2008
	SUSE 11.0 06/19/2008
	Ubuntu 8.04 04/24/2008
	_EOF_
	)
	[ "$output" == "$expect" ]


	# Use -t to change field separator for input and output.  -t "\t" doesn't work for join. Use literal tab or $'\t' in bash
	run join -t '	' <(echo "$test_string1") <(echo "$test_string2")
	expect=$(cat <<- _EOF_
	SUSE	10.2	12/07/2006
	Fedora	10	11/25/2008
	SUSE	11.0	06/19/2008
	Ubuntu	8.04	04/24/2008
	_EOF_
	)
	[ "$output" == "$expect" ]

	run join -t $'\t' <(echo "$test_string1") <(echo "$test_string2")
	[ "$output" == "$expect" ]


	test_string1=$(cat <<- _EOF_
	12/07/2006	10.2
	11/25/2008	10
	06/19/2008	11.0
	04/24/2008	8.04
	_EOF_
	)
	# Use -1 FIELD -2 FIELD if you want to join with the field other than the first field.
	run join -1 1 -2 2 -t $'\t' <(echo "$test_string1") <(echo "$test_string2")
	expect=$(cat <<- _EOF_
	12/07/2006	10.2	SUSE
	11/25/2008	10	Fedora
	06/19/2008	11.0	SUSE
	04/24/2008	8.04	Ubuntu
	_EOF_
	)
	[ "$output" == "$expect" ]

	# -1 or -2 can be omitted if the field num is 1
	run join -2 2 -t $'\t' <(echo "$test_string1") <(echo "$test_string2")
	[ "$output" == "$expect" ]


	# When FILE1 or FILE2 (not both) is -, read standard input. 
	run join -2 2 -t $'\t' <(echo "$test_string1") - <<<$test_string2
	[ "$output" == "$expect" ]
}
