#!/usr/bin/env bats

@test "tr" {
	# The tr command is a character translation filter, reading standard input and either deleting specific characters or substituting one character for another. tr cannot operate on files directly, you have to pipe them into stdin.

	run tr abc def <<< "carbon"
	[ "$output" == "fdreon" ]

	run tr a-z A-Z <<< "carbon"
	[ "$output" == "CARBON" ]

	# Some version of tr requires character range surrounded by square brackets
	run tr "[a-z]" "[A-Z]" <<< "carbon"
	[ "$output" == "CARBON" ]

	run tr b '\n' <<< "carbon"
	expect=$(cat <<- _EOF_
	car
	on
	_EOF_
	)
	[ "$output" == "$expect" ]

	# Use -d to delete characters
	run tr -d car <<< "carbon cater"
	[ "$output" == "bon te" ]

	# The -s (squeeze) option of tr removes multiple consecutive occurrences of the same character in the second argument.
	run tr -s " " <<< "carbon     cater"
	[ "$output" == "carbon cater" ]

	run tr -s " " "&" <<< "carbon     cater"
	[ "$output" == "carbon&cater" ]

	run tr -s car <<< "ccccaaaarrrr"
	[ "$output" == "car" ]

	# tr allows you to specify characters as octal values by preceding the value with a backslash
	output=$(echo -e "carbon\rcater" | tr "\015" "\012")
	expect=$(cat <<- _EOF_
	carbon
	cater
	_EOF_
	)
	[ "$output" == "$expect" ]
}
