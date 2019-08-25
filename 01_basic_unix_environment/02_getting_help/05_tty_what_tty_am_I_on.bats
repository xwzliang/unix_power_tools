#!/usr/bin/env bats

@test "test tty" {
	run tty
	echo "# Your tty is $output" >&3
	[[ "$output" =~ /dev/pts/[0-9]+ ]]
}
