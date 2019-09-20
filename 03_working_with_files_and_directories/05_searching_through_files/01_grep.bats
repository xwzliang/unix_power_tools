#!/usr/bin/env bats

@test "grep" {
	rm -rf tmp
	mkdir tmp
	cd tmp

	ls /bin > list_bin
	ls /usr/bin > list_usr_bin
	ls /sbin > list_sbin
	ls /usr/sbin > list_usr_sbin

	expect=$(cat <<- _EOF_
	list_bin:bzip2
	list_bin:bzip2recover
	_EOF_
	)
	run grep bzip list*
	[ "$output" == "$expect" ]

	# Use grep -h to suppress file names in output
	expect=$(cat <<- _EOF_
	bzip2
	bzip2recover
	_EOF_
	)
	run grep -h bzip list*
	[ "$output" == "$expect" ]

	# Use grep -l to list files whose contents match the pattern
	run grep -l bzip list*
	[ "$output" == "list_bin" ]
	# Use grep -L to list files whose contents do not match the pattern
	expect=$(cat <<- _EOF_
	list_sbin
	list_usr_bin
	list_usr_sbin
	_EOF_
	)
	run grep -L bzip list*
	[ "$output" == "$expect" ]

	# Use grep -v to find lines which do not match the pattern
	output=$(grep -h bzip list* | grep -v cover)
	[ "$output" == "bzip2" ]

	# Use grep -w to find lines which match the pattern as a whole word
	run grep -h -w 'bzip.' list*
	[ "$output" == "bzip2" ]

	# Use grep -c to output counts of match
	expect=$(cat <<- _EOF_
	list_bin:5
	list_sbin:0
	list_usr_bin:16
	list_usr_sbin:0
	_EOF_
	)
	run grep -c zip list*
	[ "$output" == "$expect" ]

	# Use grep -C num to output context before and after match
	expect=$(cat <<- _EOF_
	bzfgrep
	bzgrep
	bzip2
	bzip2recover
	bzless
	_EOF_
	)
	run grep -C 2 -h -w 'bzip.' list*
	[ "$output" == "$expect" ]
	# Use grep -B num to output context lines before match
	# Use grep -A num to output context lines after match

	# Use grep -i to ignore case
	run grep xor list*
	[ "$output" == "" ]
	run grep -i xor list*
	[ "$output" == "list_usr_bin:Xorg" ]

	# Use grep -n to output match lines with line number
	run grep -i -n xor list*
	[ "$output" == "list_usr_bin:2261:Xorg" ]

	# Use grep -f to read patterns from file, one pattern per line, and search for all the items in the list with a single invocation of the program.
	echo -e "bzip\ngrep" > pattern.tmp
	expect=$(cat <<- _EOF_
	bzegrep
	bzfgrep
	bzgrep
	bzip2
	bzip2recover
	egrep
	fgrep
	grep
	zegrep
	zfgrep
	zgrep
	agrep
	grepdiff
	lzegrep
	lzfgrep
	lzgrep
	msggrep
	pgrep
	ptargrep
	rgrep
	xzegrep
	xzfgrep
	xzgrep
	zipgrep
	_EOF_
	)
	# -f should be right before file, the grep -f -h file will not work
	run grep -h -f pattern.tmp list*
	[ "$output" == "$expect" ]

	# grep accepts BRE(basic regular expression) by default, these metacharacters are recognized: ^ $ . [ ] *
	# All other characters are considered literals. However (and this is the fun part), the characters () {} are treated as metacharacters in BRE if they are escaped with a backslash
	# grep -E (and egrep) accepts ERE(extended regular expression), the following metacharacters are added: ( ) { } ? + |

	# grep also accepts POSIX Character Classes:
	# [:alnum:] The alphanumeric characters; in ASCII, equivalent to [A-Za-z0-9] 
	# [:word:] The same as [:alnum:], with the addition of the underscore character (_) 
	# [:alpha:] The alphabetic characters; in ASCII, equivalent to [A-Za-z] 
	# [:blank:] Includes the space and tab characters 
	# [:cntrl:] The ASCII control codes; includes the ASCII characters 0 through 31 and 127 
	# [:digit:] The numerals 0 through 9 
	# [:graph:] The visible characters; in ASCII, includes characters 33 through 126 
	# [:lower:] The lowercase letters 
	# [:punct:] The punctuation characters; in ASCII, equivalent to [-!"#$%&'()*+,./:;<=>?@[\\\]_`{|}~] 
	# [:print:] The printable characters; all the characters in [:graph:] plus the space character 
	# [:space:] The whitespace characters including space, tab, carriage return, newline, vertical tab, and form feed; in ASCII, equivalent to [ \t\r\n\v\f] 
	# [:upper:] The uppercase characters 
	# [:xdigit:] Characters used to express hexadecimal numbers; in ASCII, equivalent to [0-9A-Fa-f]

	expect=$(cat <<- _EOF_
	list_usr_bin:GET
	list_usr_bin:HEAD
	list_usr_bin:POST
	list_usr_bin:VBoxSDL
	list_usr_bin:X
	_EOF_
	)
	run grep -E '[[:upper:]]+$' list*
	[ "$output" == "$expect" ]
}
