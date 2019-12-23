#!/usr/bin/env bats

@test "split" {
	rm -rf tmp
	. mk_tmp_dir
	echo line{1..10} | tr ' ' '\n' > orig_file

	# -[number] will make split create files that contain at most 3 lines (default is 1000)
	split -3 orig_file
	run wc -l x*
	expect=$(cat <<- _EOF_
	 3 xaa
	 3 xab
	 3 xac
	 1 xad
	10 total
	_EOF_
	)
	# the default naming scheme, which is to append "aa", "ab", "ac", etc., to the letter "x" for each subsequent filename.
	[ "$output" == "$expect" ]
	run cat xaa
	expect=$(cat <<- _EOF_
	line1
	line2
	line3
	_EOF_
	)
	[ "$output" == "$expect" ]
	rm x*


	# You can change the split files' name prefix by providing it after the file
	split -3 orig_file split.part.
	run wc -l split.part.*
	expect=$(cat <<- _EOF_
	 3 split.part.aa
	 3 split.part.ab
	 3 split.part.ac
	 1 split.part.ad
	10 total
	_EOF_
	)
	[ "$output" == "$expect" ]
}
