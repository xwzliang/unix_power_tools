#!/usr/bin/env bats

@test "test tar" {
	. mk_tmp_dir
	mkdir -p playground/dir_{00{1..2},0{30..32}}
	touch playground/dir_{00{1..2},0{30..32}}/file_{A..C}

	# tar mode[options] pathname...

	# tar modes:
	# c Create an archive from a list of files and/or directories.  
	# x Extract an archive.  
	# r Append specified pathnames to an archive
	# t List the contents of an archive.

	# Create a tar
	tar cf playground.tar playground
	# We can see that the mode and the f option, which is used to specify the name of the tar archive, may be joined together and do not require a leading dash. Note, however, that the mode must always be specified first, before any other option.
	[ -e playground.tar ]

	# List the contents of a tar
	expect=$(cat <<- _EOF_
	playground/
	playground/dir_031/
	playground/dir_031/file_B
	playground/dir_031/file_A
	playground/dir_031/file_C
	playground/dir_002/
	playground/dir_002/file_B
	playground/dir_002/file_A
	playground/dir_002/file_C
	playground/dir_001/
	playground/dir_001/file_B
	playground/dir_001/file_A
	playground/dir_001/file_C
	playground/dir_030/
	playground/dir_030/file_B
	playground/dir_030/file_A
	playground/dir_030/file_C
	playground/dir_032/
	playground/dir_032/file_B
	playground/dir_032/file_A
	playground/dir_032/file_C
	_EOF_
	)
	run tar tf playground.tar
	[ "$output" == "$expect" ]
	# Use tar tvf playground.tar for a more detailed listing like ls -l

	# Extract the tar to a new location
	mkdir foo
	cd foo
	tar xf ../playground.tar
	[ -d ./playground ]

	rm -rf playground

	# If we wanted to extract a single file from an archive:
	tar xf ../playground.tar playground/dir_031/file_B
	run ls -R
	expect=$(cat <<- _EOF_
	.:
	playground

	./playground:
	dir_031

	./playground/dir_031:
	file_B
	_EOF_
	)
	[ "$output" == "$expect" ]

	rm -rf playground

	# Use wildcards in specified pathname (GNU version of tar)
	tar xf ../playground.tar --wildcards 'playground/dir_*/file_A'
	run find . -type f
	expect=$(cat <<- _EOF_
	./playground/dir_031/file_A
	./playground/dir_002/file_A
	./playground/dir_001/file_A
	./playground/dir_030/file_A
	./playground/dir_032/file_A
	_EOF_
	)
	[ "$output" == "$expect" ]

	cd ..
	rm -rf foo playground.tar

	# tar is often used in conjuction with find to produce archives
	# we invoke tar in the append mode (r) to add the matching files to the archive playground.tar
	find playground -name 'file_A' -exec tar rf playground.tar '{}' '+'
	mkdir bar1
	cd bar1
	tar xf ../playground.tar
	run find . -type f
	[ "$output" == "$expect" ]
	
	cd ..
	# tar can also use of both stdin and stdout
	# If the filename - is specified, it is taken to mean stdout or atdin, as needed (This is a widely used convention)
	find playground -name 'file_A' | tar cf - -T - | gzip > playground.tgz
	# first - after cf tells tar to output to stdout, -T is --files-from option, - after -T tells tar to use files path from stdin
	mkdir bar2
	cd bar2
	zcat ../playground.tgz | tar xf -
	# - in here means stdin
	run find . -type f
	[ "$output" == "$expect" ]

	cd ..
	rm playground.tgz

	# modern versions of GNU tar support both gzip and bzip2 compres-sion directly with the use of the z and j options, respectively.
	find playground -name 'file_A' | tar czf playground.tgz -T -
	[ -e playground.tgz ]
	run tar tf playground.tgz
	expect=$(cat <<- _EOF_
	playground/dir_031/file_A
	playground/dir_002/file_A
	playground/dir_001/file_A
	playground/dir_030/file_A
	playground/dir_032/file_A
	_EOF_
	)
	[ "$output" == "$expect" ]
	find playground -name 'file_A' | tar cjf playground.tbz -T -
	[ -e playground.tbz ]
	run tar tf playground.tbz
	[ "$output" == "$expect" ]

	# Transfer files between systems over network using tar
	# ssh remote-machine 'tar cf - Documents' | tar xf -
}
