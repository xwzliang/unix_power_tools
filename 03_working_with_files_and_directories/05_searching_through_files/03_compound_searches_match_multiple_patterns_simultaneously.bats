#!/usr/bin/env bats

@test "compound searches" {
	input=$(cat <<- _EOF_
	A cat, a dog, a bird
	cat
	dog
	bird
	_EOF_
	)

	expect="A cat, a dog, a bird"

	# Use grep
	output=$(grep cat <<<$input | grep dog | grep bird)
	[ "$output" == "$expect" ]

	# Use agrep ( supplied by the glimpse package )
	output=$(agrep 'cat;dog;bird' <<< $input)
	[ "$output" == "$expect" ]

	# Use sed
	output=$(sed '/dog/!d; /cat/!d; /bird/!d' <<< $input)
	[ "$output" == "$expect" ]

	# Use awk
	output=$(awk '/dog/ && /cat/ && /bird/' <<< $input)
	[ "$output" == "$expect" ]

	# Use perl
	# -n                assume "while (<>) { ... }" loop around program
	# -e program        one line of program
	output=$(perl -ne 'print if /dog/ && /cat/ && /bird/' <<< $input)
	[ "$output" == "$expect" ]


	# find paragraph that contains all the words (seperated by empty line)
	input=$(cat <<- _EOF_
	A cat, a dog, a bird
	cat

	dog
	bird
	_EOF_
	)
	expect=$(cat <<- _EOF_
	A cat, a dog, a bird
	cat
	_EOF_
	)

	# RS="" in awk will output paragraph
	output=$(awk '/dog/ && /cat/ && /bird/' RS=  <<< $input)
	[ "$output" == "$expect" ]

	# -00 option in perl will output paragraph
	output=$(perl -n00e 'print "$_\n" if /dog/ && /cat/ && /bird/' <<< $input)
	[ "$output" == "$expect" ]
	

	# only list files that contain all these words

	# perl -ln0e 'print $ARGV if /cat/ && /dog/ && /bird/' files
	# grep -l cat files | xargs grep -l dog | xargs grep -l bird
}
