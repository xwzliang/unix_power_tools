#!/usr/bin/env bats

@test "pr" {
	# The pr command is famous for printing a file neatly on a page — with margins at top and bottom, filename, date, and page numbers. It can also print text in columns: one file per column or many columns for each file.

	test_string1=$(cat <<- _EOF_
	Line1
	Line2
	Line3
	Line4
	Line5
	Line6
	_EOF_
	)
	test_string2=$(cat <<- _EOF_
	text
	text
	text
	_EOF_
	)


	# run pr <(cat <<< $test_string2)
	# Default output is like this:
# 
# 
# 2019-12-27 12:09                    /dev/fd/63                    Page 1
# 
# 
# text
# text
# text


	# The -t option takes away the heading and margins at the top and bottom of each page.
	run pr -t <(cat <<< $test_string2)
	expect=$(cat <<- _EOF_
	text
	text
	text
	_EOF_
	)
	[ "$output" == "$expect" ]


	# The -m option reads all files on the command line simultaneously and prints each in its own column
	run pr -m -t <(cat <<< $test_string1) <(cat <<< $test_string2) <(cat <<< $test_string2) 

	expect=$(cat <<- _EOF_
	Line1			text			text
	Line2			text			text
	Line3			text			text
	Line4						
	Line5						
	Line6						
	_EOF_
	)
	[ "$output" == "$expect" ]
	expect=$(cat <<- '_EOF_'
	Line1^I^I^Itext^I^I^Itext$
	Line2^I^I^Itext^I^I^Itext$
	Line3^I^I^Itext^I^I^Itext$
	Line4^I^I^I^I^I^I$
	Line5^I^I^I^I^I^I$
	Line6^I^I^I^I^I^I$
	_EOF_
	)
	output=$(echo "$output" | cat -A)
	[ "$output" == "$expect" ]


	# An option that's a number will print a file in that number of columns. For instance, the -3 option prints a file in three columns. The file is read, line by line, until the first column is full (by default, that takes 56 lines). Next, the second column is filled. Then, the third column is filled. If there's more of the file, the first column of page 2 is filled — and the cycle repeats
	run pr -t -3 <(cat <<< $test_string1)

	expect=$(cat <<- _EOF_
	Line1			Line3			Line5
	Line2			Line4			Line6
	_EOF_
	)
	[ "$output" == "$expect" ]


	# Use -l to set page length (how many lines a page)
	run pr -t -3 -l 1 <<< $test_string1

	expect=$(cat <<- _EOF_
	Line1			Line2			Line3
	Line4			Line5			Line6
	_EOF_
	)
	# By changing page length to 1, we can output first three lines across the top of each column
	[ "$output" == "$expect" ]

	# -l implies -t when the page length is <= 10
	run pr -3 -l 1 <<< $test_string1
	[ "$output" == "$expect" ]
}
