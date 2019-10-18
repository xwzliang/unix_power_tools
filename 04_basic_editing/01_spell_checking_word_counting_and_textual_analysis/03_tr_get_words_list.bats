#!/usr/bin/env bats

@test "tr to get the words list" {
	test_string=$(cat <<- _EOF_
	The deroff command was designed to strip out troff Section 45.11) constructs and punctuation from files. The command deroff -w will give you a list of just the words in a document; pipe to sort -u (Section 22.6) if you want only one of each.  deroff has one major failing, though. It considers a word as just a string of characters beginning with a letter of the alphabet. A single character won't do, which leaves out one-letter words like the indefinite article "A."
	_EOF_
	)
	run tr -cs A-Za-z '\012' <<< $test_string
	# The -c option "complements" the first string passed to tr; -s squeezes out repeated characters. This has the effect of saying: "Take any nonalphabetic characters you find (one or more) and convert them to newlines (\012)."
	expect=$(cat <<- _EOF_
	The
	deroff
	command
	was
	designed
	to
	strip
	out
	troff
	Section
	constructs
	and
	punctuation
	from
	files
	The
	command
	deroff
	w
	will
	give
	you
	a
	list
	of
	just
	the
	words
	in
	a
	document
	pipe
	to
	sort
	u
	Section
	if
	you
	want
	only
	one
	of
	each
	deroff
	has
	one
	major
	failing
	though
	It
	considers
	a
	word
	as
	just
	a
	string
	of
	characters
	beginning
	with
	a
	letter
	of
	the
	alphabet
	A
	single
	character
	won
	t
	do
	which
	leaves
	out
	one
	letter
	words
	like
	the
	indefinite
	article
	A
	_EOF_
	)
	[ "$output" == "$expect" ]
}
