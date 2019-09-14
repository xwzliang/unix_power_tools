#!/usr/bin/env bats

@test "compare files" {
	rm -rf tmp
	mkdir tmp
	cd tmp
	echo {b..h} | tr " " "\n" > file1
	echo {a..f} | tr " " "\n" > file2

	# Using diff

	# diff prints message using ed-like notation (a for append, c for change, and d for delete)
	# diff is prescriptive, describing what changes need to be made to the first file to make it the same as the second file
	# The < character precedes lines from the first file and > precedes lines from the second file.
	expect=$(cat <<- _EOF_
	0a1
	> a
	6,7d6
	< g
	< h
	_EOF_
	)
	run diff file1 file2
	[ "$output" == "$expect" ]

	# Use diff -e to generate an ed script
	expect=$(cat <<- _EOF_
	6,7d
	0a
	a
	.
	_EOF_
	)
	run diff -e file1 file2
	[ "$output" == "$expect" ]

	# Use diff3 to campare 3 files
	# diff3 shows what needs to be done for 3 files to bring them into agreement
	echo {c..i} | tr " " "\n" > file3
	expect=$(cat <<- _EOF_
	====
	1:1c
	  b
	2:1,2c
	  a
	  b
	3:0a
	====
	1:6,7c
	  g
	  h
	2:6a
	3:5,7c
	  g
	  h
	  i
	_EOF_
	)
	run diff3 file{1..3}
	[ "$output" == "$expect" ]

	# diff with context

	# Use diff -c
	# Headers omitted, contents like 
	#*** file1   2019-09-14 20:25:45.902824569 +0800
	#--- file2   2019-09-14 20:25:45.914824292 +0800
	expect=$(cat <<- _EOF_
	***************
	*** 1,7 ****
	  b
	  c
	  d
	  e
	  f
	- g
	- h
	--- 1,6 ----
	+ a
	  b
	  c
	  d
	  e
	  f
	_EOF_
	)
	run diff -c file1 file2
	[[ "$output" =~ "$expect" ]]
	# -c default shows three lines content, -c2 will change to two lines
	expect=$(cat <<- _EOF_
	***************
	*** 1,2 ****
	--- 1,3 ----
	+ a
	  b
	  c
	***************
	*** 4,7 ****
	  e
	  f
	- g
	- h
	--- 5,6 ----
	_EOF_
	)
	run diff -c2 file1 file2
	[[ "$output" =~ "$expect" ]]

	# use diff -u to generate output with unified context
	# header omitted, contents like:
	#--- file1       2019-09-14 20:46:06.444191810 +0800
	#+++ file2       2019-09-14 20:46:06.456191544 +0800
	expect=$(cat <<- _EOF_
	@@ -1,7 +1,6 @@
	+a
	 b
	 c
	 d
	 e
	 f
	-g
	-h
	_EOF_
	)
	run diff -u file1 file2
	[[ "$output" =~ "$expect" ]]
	# -u2 has similar effect as -c2
}
