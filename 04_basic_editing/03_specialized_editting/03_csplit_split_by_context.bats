#!/usr/bin/env bats

@test "csplit" {
	. mk_tmp_dir
	echo Chapter1 sectionI line{1..3} sectionII line{4..5} sectionIII line{6..8} | tr ' ' '\n' > orig_file

	# With csplit, you give the locations (line numbers or search patterns) at which to break each section
	run csplit orig_file /sectionI/ /sectionII/ /sectionIII/
	expect=$(cat <<- _EOF_
	9
	27
	22
	29
	_EOF_
	)
	# csplit will output character counts by default
	[ "$output" == "$expect" ]

	rm x*
	# use the -s option to suppress the display of the character counts
	csplit -s orig_file /sectionI/ /sectionII/ /sectionIII/
	run wc -l x*
	expect=$(cat <<- _EOF_
	 1 xx00
	 4 xx01
	 3 xx02
	 4 xx03
	12 total
	_EOF_
	)
	# Note that the first file (xx00) contains any text up to but not including the first pattern, and xx01 contains the first section, as you'd expect. This is why the naming scheme begins with 00. (If outline had begun immediately with a sectionI, xx01 would still contain Section I, but in this case xx00 would be empty.)
	[ "$output" == "$expect" ]

	rm x*
	csplit -s orig_file /^sectionII*/ {2}
	# This command splits the file at the first occurrence of pattern, and the number in braces tells csplit to repeat the split 2 more times.
	run wc -l x*
	[ "$output" == "$expect" ]

	rm x*
	csplit -sk orig_file /^sectionII*/ {10} &>/dev/null || true
	# If you don't know how many times the pattern will be encountered, you can make the repeated number big enough. But then an "out of range" error will occur, and all files will be removed. Use -k option to keep the files even there's an error.
	run wc -l x*
	[ "$output" == "$expect" ]

	rm x*
	csplit -s orig_file 2 6 9
	# The csplit command takes line-number arguments in addition to patterns. 
	run wc -l x*
	[ "$output" == "$expect" ]
	# csplit works like split if you repeat the argument. The command: 
	# 	csplit file 10 {18}
	# breaks the file into 19 segments of 10 lines each.

	run cat xx00
	expect=$(cat <<- _EOF_
	Chapter1
	_EOF_
	)
	[ "$output" == "$expect" ]
	run cat xx01
	expect=$(cat <<- _EOF_
	sectionI
	line1
	line2
	line3
	_EOF_
	)
	[ "$output" == "$expect" ]


	rm x*
	csplit -s orig_file /^sectionII*/+1 {2}
	# csplit allows you to break a file at some number of lines above or below a given search pattern. The "+1" after the pattern tells csplit to split at one line after the pattern
	run cat xx00
	expect=$(cat <<- _EOF_
	Chapter1
	sectionI
	_EOF_
	)
	[ "$output" == "$expect" ]
	run cat xx01
	expect=$(cat <<- _EOF_
	line1
	line2
	line3
	sectionII
	_EOF_
	)
	[ "$output" == "$expect" ]

	csplit -s orig_file /^sectionII*/-1 {2}
	# Use "-1" to split at one line before the pattern
	run cat xx01
	expect=$(cat <<- _EOF_
	Chapter1
	sectionI
	line1
	line2
	_EOF_
	)
	[ "$output" == "$expect" ]


	rm x*
	# If you don't want to save the text that occurs before a specified pattern, use a percent sign as the pattern delimiter. (the first file is still named xx00)
	csplit -s orig_file %sectionI% /sectionII*/ {1}
	run wc -l x*
	expect=$(cat <<- _EOF_
	 4 xx00
	 3 xx01
	 4 xx02
	11 total
	_EOF_
	)
	[ "$output" == "$expect" ]


	rm x*
	# Use -f to specify filename prefix other than xx
	csplit -s -f file.part. orig_file %sectionI% /sectionII*/ {1}
	run wc -l file*
	expect=$(cat <<- _EOF_
	 4 file.part.00
	 3 file.part.01
	 4 file.part.02
	11 total
	_EOF_
	)
	[ "$output" == "$expect" ]


}
 
