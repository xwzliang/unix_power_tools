#!/usr/bin/env bats

@test "empty a file" {
	# Emptying the file doesn't break the association, and so it clears the file without affecting the logging program.
	# When you remove a file and create a new one with the same name, the new file will have your default permissions and ownership. It's better to empty the file now, then add new text later; this won't change the permissions and ownership.
	# You can use the empty files as "place markers" to remind you that something was there or belongs there.
	rm -rf tmp
	mkdir tmp
	cd tmp

	echo "Hello" > file
	run cat file
	[ "$output" == "Hello" ]

	# In Bourne-type shells like sh and bash, the most efficient way is to redirect the output of a null command:
	> file
	run cat file
	[ "$output" == "" ]

	echo "Hello" > file
	# cat the Unix empty file /dev/null on top of the file
	cat /dev/null > file
	run cat file
	[ "$output" == "" ]
}
