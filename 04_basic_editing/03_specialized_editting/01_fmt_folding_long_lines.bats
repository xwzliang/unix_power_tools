#!/usr/bin/env bats

@test "fmt" {
	test_string=$(cat << _EOF_
	text text  text text,  text text text text text text
text text text text text text text.
text text text.
_EOF_
)
	run fmt -40 <<< $test_string
	# Reformat your file to have lines with no more than 40 characters on each. Default is 75.
	expect=$(cat << _EOF_
	text text  text text,  text
	text text text text text
text text text text text text text.
text text text.
_EOF_
)
	# The first line of test_string is considered one sentence, so the indentation is preserved.
	[ "$output" == "$expect" ]

	# -w 40 has the same meaning as -40, sets width for fmt
	run fmt -w 40 <<< $test_string
	[ "$output" == "$expect" ]

	# The -t option, short for --tagged-paragraph mode, tells fmt to preserve the paragraph's initial indent but align the rest of the lines with the left margin of the second line.
	run fmt -tw 40 <<< $test_string
	expect=$(cat << _EOF_
	text text  text text,  text
text text text text text text text text
text text text text.  text text text.
_EOF_
)
	[ "$output" == "$expect" ]

	# The -u option, short for --uniform-spacing, squashes all the inappropriate whitespace in the lines. (one space between words, two after sentences)
	run fmt -utw 40 <<< $test_string
	expect=$(cat << _EOF_
	text text text text, text text
text text text text text text text text
text text text.  text text text.
_EOF_
)
	[ "$output" == "$expect" ]

	# The -s (split-only) option breaks long lines at whitespace but doesn't join short lines to form longer ones.
	run fmt -suw 40 <<< $test_string
	expect=$(cat << _EOF_
	text text text text, text text
	text text text text
text text text text text text text.
text text text.
_EOF_
)
	# -t doesn't have effects here
	[ "$output" == "$expect" ]
	run fmt -sutw 40 <<< $test_string
	[ "$output" == "$expect" ]


	# -p can be used to reformat comments in code, you have to tell fmt -p what the prefix characters are.
	test_string=$(cat << _EOF_
/* 
* This file, load.cc, reads an input 
* data file. 
* Each input line is added to a new node 
* of type struct Node. 
*/
_EOF_
)
	run fmt -p '*' <<< $test_string
	expect=$(cat << _EOF_
/* 
* This file, load.cc, reads an input data file.  Each input line is
* added to a new node of type struct Node.
*/
_EOF_
)
	[ "$output" == "$expect" ]

}
