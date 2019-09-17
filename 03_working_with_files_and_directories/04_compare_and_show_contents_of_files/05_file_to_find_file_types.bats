#!/usr/bin/env bats

@test "file" {
	# Use file to find file types
	run file /bin/sh
	[ "$output" == "/bin/sh: symbolic link to dash" ]
	run file /bin/dash
	expect="/bin/dash: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/l, for GNU/Linux 3.2.0, BuildID[sha1]=a783260e3a5fe0afdae77417eea7fbf8d645219e, stripped"
	[ "$output" == "$expect" ]
	run file ../02_finding_files_with_find/03_searching_for_old_files.sh
	expect="../02_finding_files_with_find/03_searching_for_old_files.sh: Bourne-Again shell script, ASCII text executable, with very long lines"
	[ "$output" == "$expect" ]

	# If file cannot recognize certain type, edit /etc/magic file for adding customized filetypes
	# 0     string     head     RCS archive
	# This says, "The file is an RCS archive if you find the string head at an offset of 0 bytes from the beginning of the file."
}
