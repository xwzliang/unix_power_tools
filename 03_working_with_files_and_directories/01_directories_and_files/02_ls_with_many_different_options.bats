#!/usr/bin/env  bats

@test "ls -t -u -c" {
	mkdir -p tmp
	rm -r tmp
	mkdir -p tmp
	cd tmp
	touch file{1..3}

	# sort by modification time with -t
	run ls -t
	[ "$output" == "$(echo -e "file1\nfile2\nfile3")" ]

	cat file2
	run ls -t
	[ "$output" == "$(echo -e "file1\nfile2\nfile3")" ]

	# sort by access time with -u
	run ls -u
	[ "$output" == "$(echo -e "file2\nfile1\nfile3")" ]

	chmod 777 file3
	run ls -t
	[ "$output" == "$(echo -e "file1\nfile2\nfile3")" ]

	# sort by inode change time with -c. The inode time tells when the file was created, when you used chmod to change the permissions, and so on.
	run ls -c
	[ "$output" == "$(echo -e "file3\nfile1\nfile2")" ]

	# list output in columns with -C
	run ls -cC
	[[ "$output" =~ file3.*file1.*file2 ]]

	# sort in reverse order with -r
	run ls -r
	[ "$output" == "$(echo -e "file3\nfile2\nfile1")" ]

	mkdir -p dir{1..2}
	touch dir{1..2}/file
	run ls
	[ "$output" == "$(echo -e "dir1\ndir2\nfile1\nfile2\nfile3")" ]

	# list all items including subdirectories
	run ls -R
	[ "$output" == "$(echo -e ".:\ndir1\ndir2\nfile1\nfile2\nfile3\n\n./dir1:\nfile\n\n./dir2:\nfile")" ]

	run ls dir1
	[ "$output" == "file" ]

	# list the directory itself with -d
	run ls -d dir1
	[ "$output" == "dir1" ]

	# -d is especially handy when you're trying to list the names of some directories that match a wildcard.
	run ls -d dir*
	[ "$output" == "$(echo -e "dir1\ndir2")" ]

	# Add indicators with -F: Write a ( '/' ) immediately after each pathname that is a directory, an ( '*' ) after each that is executable, a ( '|' ) after each that is a FIFO, and an at-sign ( '@' ) after each that is a symbolic link. ‘=’ for sockets, ‘>’ for doors
	run ls -F
	[ "$output" == "$(echo -e "dir1/\ndir2/\nfile1\nfile2\nfile3*")" ]

	# Ingore list given pattern with -I
	run ls -I "dir*"	# Quotes needed
	[ "$output" == "$(echo -e "file1\nfile2\nfile3")" ]

	cd dir1
	echo "Hakuna Matata" > larger_file

	# Sort by file size largest first with -S
	run ls -S
	[ "$output" == "$(echo -e "larger_file\nfile")" ]

	rm larger_file
	touch .hidden
	run ls
	[ "$output" == "file" ]

	# list all (including hidden file started with dot) with -a
	run ls -a
	[ "$output" == "$(echo -e ".\n..\nfile\n.hidden")" ]

	# list all without . and .. with -A
	run ls -A
	[ "$output" == "$(echo -e "file\n.hidden")" ]

	touch "a b c.file"

	# list with double quotes around the name with -Q (useful when filename has spaces)
	run ls -Q
	[ "$output" == "$(echo -e "\"a b c.file\"\n\"file\"")" ]

	# If file name has nonprintable characters, use ls -q to print question mark ?, use ls -b to print the octal value preceeded by a backslash

	cd ../..
	rm -r tmp
}
