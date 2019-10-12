#!/usr/bin/env bats

@test "test aspell" {
	test_string="hellp world"
	# use aspell list to list words that might be misspelled
	output=$(aspell list <<< $test_string )
	expect="hellp"
	[ "$output" == "$expect" ]

	# use aspell -a to get list and suggestions
	output=$(aspell -a  <<< $test_string )
	# A line starting with & means the speller has suggestions. Then it repeats the word, the number of suggestions it has for that word, the character position that the word had on the input line, and finally the suggestions.
	expect=$(cat <<- _EOF_
	@(#) International Ispell Version 3.1.20 (but really Aspell 0.60.7-20110707)
	& hellp 31 0: help, hello, hell, hellos, he'll, helps, helper, hep, Heller, hell's, whelp, Hall, Heep, Hill, Hull, hall, heal, heap, heel, hill, hull, held, helm, hemp, kelp, yelp, Holly, hilly, holly, hello's, help's
	*

	_EOF_
	)
	[ "$output" == "$expect" ]

	# Add word to aspell's personal dict
	aspell_dict=$HOME/.aspell.en.pws
	echo "hellp" >> $aspell_dict
	output=$(aspell list <<< $test_string )
	# Now both words are considered correct
	[ "$output" == "" ]
	# Now remove the last line we added in aspell's dict
	sed -i '$d' $aspell_dict

	# Use following to check and correct interactively using aspell
	# aspell check file


	# Use look to check spelling
	# The look utility displays any lines in file which contain string.  As look performs a binary search, the lines in file must be sorted (where sort(1) was given the same options -d and/or -f that look is invoked with).  
	# If file is not specified, the file /usr/share/dict/words is used, only alphanumeric characters are compared and the case of alphabetic characters is ignored.
	run look worl
	expect=$(cat <<- _EOF_
	world
	world's
	worldlier
	worldliest
	worldliness
	worldliness's
	worldly
	worlds
	worldwide
	_EOF_
	)
	[ "$output" == "$expect" ]
}
