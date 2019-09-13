#!/usr/bin/env bats

@test "copy directory trees" {
	rm -rf tmp
	mkdir tmp
	cd tmp
	mkdir dir{1..3}
	cd dir1
	mkdir in_dir{1..2}
	touch file{1..2}
	ln -s file1 symlink

	# Use -L to test a symlink
	[ -L symlink ]
	[ ! -L file1 ]

	# Use cp -r to copy recursively
	cp -r . ../dir2
	cd ../dir2
	run ls
	expect=$(cat <<- _EOF_
	file1
	file2
	in_dir1
	in_dir2
	symlink
	_EOF_
	)
	[ "$output" == "$expect" ]
	# symlink is still a symbolic link
	[ -L symlink ]

	run ls -l symlink
	# symlink points to file1 in the same folder now
	[[ "$output" =~ "symlink -> file1" ]]

	# Use wildcards to select files or dirs to copy
	cd ../dir3
	cp -r ../dir1/*[12] .
	run ls
	expect=$(cat <<- _EOF_
	file1
	file2
	in_dir1
	in_dir2
	_EOF_
	)
	[ "$output" == "$expect" ]
	rm -rf ./*
	# Use curly braces to specify files or dirs to copy
	# Note there cannot be space in it!
	cp -r ../dir1/{in_dir1,file2,symlink} .
	run ls
	expect=$(cat <<- _EOF_
	file2
	in_dir1
	symlink
	_EOF_
	)
	[ "$output" == "$expect" ]
	rm -rf ./*


	# If copy to or from remote server, use scp -r
	# scp -r mydata bigserver:backup
	# scp -r bigserver:backup mydata 
	# Relative pathnames for remote files are always relative to your home directory on the remote machine.


	# Copy use tar
	rm -rf ./*
	cd ../dir1
	tar -cf - . | (cd ../dir3 && tar -xvf -)
	cd ../dir2
	run ls
	expect=$(cat <<- _EOF_
	file1
	file2
	in_dir1
	in_dir2
	symlink
	_EOF_
	)
	[ "$output" == "$expect" ]
}
