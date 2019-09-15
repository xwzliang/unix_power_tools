#!/usr/bin/env bats

@test "cat and od to show nonprinting chars" {
	ed_bin=/bin/ed

	# Use cat -v to show nonprinting chars, -t will show tab \t as ^I, -e will show $ at the end of each line
	expect=$(cat <<- _EOF_
	^?ELF^B^A^A^@^@^@^@^@^@^@^@^@^C^@>^@^A^@^@^@M-^@^Y^@^@^@^@^@^@@^@^@^@^@^@^@^@xM-
	B^@^@^@^@^@^@^@^@^@^@@^@8^@^I^@@^@^[^@^Z^@^F^@^@^@^E^@^@^@@^@^@^@^@^@^@^@@^@^@^@
	^@^@^@^@@^@^@^@^@^@^@^@M-x^A^@^@^@^@^@^@M-x^A^@^@^@^@^@^@^H^@^@^@^@^@^@^@^C^@^@^
	@^D^@^@^@8^B^@^@^@^@^@^@8^B^@^@^@^@^@^@8^B^@^@^@^@^@^@^\^@^@^@^@^@^@^@^\^@^@^@^@
	^@^@^@^A^@^@^@^@^@^@^@^A^@^@^@^E^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@
	_EOF_
	)
	# fold will wrap each input line to fit in specified width
	output=$(cat -vt $ed_bin | fold -80 | head -5)
	[ "$output" == "$expect" ]

	# Use od to see the binary
	expect=$(cat <<- _EOF_
	0000000 042577 043114 000402 000001 000000 000000 000000 000000
	0000020 000003 000076 000001 000000 014600 000000 000000 000000
	0000040 000100 000000 000000 000000 141170 000000 000000 000000
	0000060 000000 000000 000100 000070 000011 000100 000033 000032
	0000100 000006 000000 000005 000000 000100 000000 000000 000000
	_EOF_
	)
	output=$(od $ed_bin | fold -80 | head -5)
	[ "$output" == "$expect" ]

	# Use od -c to see octal value
	# od -c will show tab as \t, newline as \n, etc. 
	expect=$(cat <<- _EOF_
	0000000 177   E   L   F 002 001 001  \0  \0  \0  \0  \0  \0  \0  \0  \0
	0000020 003  \0   >  \0 001  \0  \0  \0 200 031  \0  \0  \0  \0  \0  \0
	0000040   @  \0  \0  \0  \0  \0  \0  \0   x 302  \0  \0  \0  \0  \0  \0
	0000060  \0  \0  \0  \0   @  \0   8  \0  \t  \0   @  \0 033  \0 032  \0
	0000100 006  \0  \0  \0 005  \0  \0  \0   @  \0  \0  \0  \0  \0  \0  \0
	_EOF_
	)
	output=$(od -c $ed_bin | fold -80 | head -5)
	[ "$output" == "$expect" ]
}
