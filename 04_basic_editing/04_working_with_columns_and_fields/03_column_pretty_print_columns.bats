#!/usr/bin/env bats

@test "column" {
	# column — columnate lists
	# -t: Determine the number of columns the input contains and create a table.  Columns are delimited with whitespace, by default, or with the characters supplied using the -s option.  Useful for pretty-printing displays.

	test_string=$(cat <<- _EOF_
	-r--r--r--    1 jpeek     1559177 Sep 19  1999 ORA_tifs.tgz
	-rw-rw-r--    1 jpeek        4106 Oct 21  1999 UPT_Russian.jpg
	dr-xr-xr-x    2 jpeek        4096 Dec 12  1999 me
	_EOF_
	)

	run column -t <(echo PERM LINKS OWNER SIZE MONTH DAY HH:MM/YEAR NAME; echo "$test_string")
	expect=$(cat <<- _EOF_
	PERM        LINKS  OWNER  SIZE     MONTH  DAY  HH:MM/YEAR  NAME
	-r--r--r--  1      jpeek  1559177  Sep    19   1999        ORA_tifs.tgz
	-rw-rw-r--  1      jpeek  4106     Oct    21   1999        UPT_Russian.jpg
	dr-xr-xr-x  2      jpeek  4096     Dec    12   1999        me
	_EOF_
	)
	[ "$output" == "$expect" ]
}
