#!/usr/bin/env bats

@test "Test whatis cat" {
	stdout="$(whatis cat)"
	# Bats' printing requirement:
	# To have text printed from within a test function you need to redirect the output to file descriptor 3, eg echo 'text' >&3. This output will become part of the TAP stream. You are encouraged to prepend text printed this way with a hash (eg echo '# text' >&3) in order to produce 100% TAP compliant output. Otherwise, depending on the 3rd-party tools you use to analyze the TAP stream, you can encounter unexpected behavior or errors.
	echo "# Output of 'whatis cat': " >&3
	echo "# $stdout" >&3
	[ "$stdout" == "cat (1)              - concatenate files and print on the standard output" ]
}
