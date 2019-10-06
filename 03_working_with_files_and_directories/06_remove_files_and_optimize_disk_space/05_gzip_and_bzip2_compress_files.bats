#!/usr/bin/env bats

@test "gzip and bzip2" {
	. mk_tmp_dir

	echo "hello" >file
	[ -e file ]

	gzip file

	# gzip will remove the original file and replace it with .gz file 
	[ ! -e file ]
	[ -e file.gz ]

	touch file1 file2

	gzip file{1..2}
	# gzip a list of files will compress each file seperately instead of compressing them into one file (that's what tar is for)
	expect=$(echo -e "file1.gz\nfile2.gz\nfile.gz")
	run ls
	[ "$output" == "$expect" ]

	# gzip -l will give information of a gz file
	run gzip -l file.gz
	expect=$(cat <<- _EOF_
         compressed        uncompressed  ratio uncompressed_name
                 31                   6 -33.3% file
	_EOF_
	)
	[ "$output" == "$expect" ]

	# To get original file back
	gunzip file.gz
	[ ! -e file.gz ]
	[ -e file ]

	# Rename the .gz file
	mv file1.gz tmp1.gz
	mv file2.gz tmp2.gz

	# gunzip the renamed file directly, the unziped file name will also be the changed version 
	gunzip tmp1.gz
	[ ! -e file1 ]
	[ -e tmp1 ]
	
	# -N option can restore the original file name
	gunzip -N tmp2.gz
	[ ! -e tmp2 ]
	[ -e file2 ]

	# gunzip -c will uncompress the file to the stdout
	ls | gzip > ls.gz
	expect=$(echo -e "file\nfile2\ntmp1")
	output=$(gunzip -c ls.gz)
	[ "$output" == "$expect" ]

	# zcat will also uncompress file to stdout
	output=$(zcat ls.gz)
	[ "$output" == "$expect" ]

	# When compressing files, you can use one of the options -1, -2, through -9 to specify the speed and quality of the compression used. -1 (also - -fast) specifies the fastest method, which compresses the files less compactly, while -9 (also - -best) uses the slowest, but best compression method. If you don't specify one of these options, the default is -6.

	rm ls.gz
	# bzip2 offers better compression than gzip
	ls | bzip2 > ls.bz2
	output=$(bunzip2 -c ls.bz2)
	[ "$output" == "$expect" ]
	# bzcat will uncompress file to stdout
	output=$(bzcat ls.bz2)
	[ "$output" == "$expect" ]
}
