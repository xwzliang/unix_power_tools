#!/usr/bin/env bats

@test "sort" {
	# sort divides each line into fields at whitespace by default(blanks or tabs), and sorts the lines by field, from left to right.

	test_string=$(cat <<- _EOF_
	Robert M Johnson      344-0909
	Lyndon B Johnson      933-1423
	Jerry O Peek          267-2345
	Timothy F O'Reilly    443-2434
	_EOF_
	)

	run sort <<< $test_string
	expect=$(cat <<- '_EOF_'
	Jerry O Peek          267-2345
	Lyndon B Johnson      933-1423
	Robert M Johnson      344-0909
	Timothy F O'Reilly    443-2434
	_EOF_
	)
	[ "$output" == "$expect" ]


	# The command-line option +n tells sort to start sorting on field n; -n tells sort to stop sorting on field n. Remember that sort counts fields from left to right, starting with 0.

	run sort +0 <<< $test_string
	# +0 has the same effect as without it
	[ "$output" == "$expect" ]

	run sort +2 <<< $test_string
	# sort by the third field (+2)
	expect=$(cat <<- '_EOF_'
	Robert M Johnson      344-0909
	Lyndon B Johnson      933-1423
	Timothy F O'Reilly    443-2434
	Jerry O Peek          267-2345
	_EOF_
	)
	# Robert M Johnson comes before Lyndon B Johnson, this is because the field after Johnson, 3 comes before 9
	[ "$output" == "$expect" ]

	run sort +2 -3 <<< $test_string
	expect=$(cat <<- '_EOF_'
	Lyndon B Johnson      933-1423
	Robert M Johnson      344-0909
	Timothy F O'Reilly    443-2434
	Jerry O Peek          267-2345
	_EOF_
	)
	# If we stop sorting at the fourth field (-3), then Robert M Johnson comes after Lyndon B Johnson
	[ "$output" == "$expect" ]

	# If we want these names sorted by last name, first name, and middle initial:
	run sort +2 -3 +0 -2 <<< $test_string
	[ "$output" == "$expect" ]


	# -n let us do a numeric sort
	run sort +3 -n <<< $test_string
	# numeric sort by the fourth field
	expect=$(cat <<- '_EOF_'
	Jerry O Peek          267-2345
	Robert M Johnson      344-0909
	Timothy F O'Reilly    443-2434
	Lyndon B Johnson      933-1423
	_EOF_
	)
	[ "$output" == "$expect" ]

	run sort +3n <<< $test_string
	# +3n has the same effect as +3 -n
	[ "$output" == "$expect" ]


	# You can specify individual columns within any field for sorting, using the notation +n.c, where n is a field number, and c is a character position within the field. Likewise, the notation -n.c says "stop sorting at the character before character c."
	# If If neither -t nor -b is provided, characters in a field are counted from the beginning of the preceding whitespace.
	run sort +2.1 <<< $test_string
	expect=$(cat <<- '_EOF_'
	Robert M Johnson      344-0909
	Lyndon B Johnson      933-1423
	Timothy F O'Reilly    443-2434
	Jerry O Peek          267-2345
	_EOF_
	)
	[ "$output" == "$expect" ]
	# +2.1 is the same as +2, because -b is not provided
	run sort +2 <<< $test_string
	[ "$output" == "$expect" ]

	# -b, --ignore-leading-blanks  ignore leading blanks
	run sort +2.1b <<< $test_string
	expect=$(cat <<- '_EOF_'
	Jerry O Peek          267-2345
	Robert M Johnson      344-0909
	Lyndon B Johnson      933-1423
	Timothy F O'Reilly    443-2434
	_EOF_
	)
	# Now since -b is provided, 2.1 is the second character at the third field
	[ "$output" == "$expect" ]


	# The -t option lets you change the field delimiter to some other character.
	run sort -t "-" +1 <<< $test_string
	expect=$(cat <<- '_EOF_'
	Robert M Johnson      344-0909
	Lyndon B Johnson      933-1423
	Jerry O Peek          267-2345
	Timothy F O'Reilly    443-2434
	_EOF_
	)
	# Sort by characters after "-"
	[ "$output" == "$expect" ]

	run sort +3.4b <<< $test_string
	# Same result when using +3.4b
	[ "$output" == "$expect" ]


	# -d, --dictionary-order      consider only blanks and alphanumeric characters(puctuations will be ignored)
	run sort -d +3.3b <<< $test_string
	# Now "-" is ignored, so we should use +3.3b to get the same result as before
	[ "$output" == "$expect" ]


	# -u, --unique	eliminate duplicate lines
	run sort +2 -3 -u <<< $test_string
	expect=$(cat <<- '_EOF_'
	Robert M Johnson      344-0909
	Timothy F O'Reilly    443-2434
	Jerry O Peek          267-2345
	_EOF_
	)
	# Only consider the third field and eliminate duplicate "Johnson" line
	[ "$output" == "$expect" ]


	# -r, --reverse               reverse the result
	run sort +2 -3 -u -r <<< $test_string
	expect=$(cat <<- '_EOF_'
	Jerry O Peek          267-2345
	Timothy F O'Reilly    443-2434
	Robert M Johnson      344-0909
	_EOF_
	)
	# Only consider the third field and eliminate duplicate "Johnson" line
	[ "$output" == "$expect" ]


	# -f, --ignore-case           fold lower case to upper case characters (case-insensitive)
	run sort -f <(cat <<-EOF 
	abc
	Abc
	abd
	EOF
	)
	expect=$(cat <<- '_EOF_'
	abc
	Abc
	abd
	_EOF_
	)
	[ "$output" == "$expect" ]
}
