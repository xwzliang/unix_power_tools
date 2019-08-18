#!/usr/bin/env bats
@test "Test whereis cat" {
	run whereis cat
	[ "$output" == "cat: /bin/cat /usr/share/man/man1/cat.1.gz" ]
	run whereis -b cat	# Only report the executable name
	[ "$output" == "cat: /bin/cat" ]
	run whereis -m cat	# Only report the location of the manual page
	[ "$output" == "cat: /usr/share/man/man1/cat.1.gz" ]
}
