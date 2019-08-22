#!/usr/bin/env bats

@test "test type" {
	run type ls
	[ "$output" == "ls is /bin/ls" ]
}

@test "test which" {
	run which ls
	[ "$output" == "/bin/ls" ]
}

# which comes in handy when a precise path is needed (using which inside of backquotes)
@test "test using which to get path" {
	run ls -l `which whatis` `which apropos`
	[ "$output" == \
"lrwxrwxrwx 1 root root     6 Aug  5  2018 /usr/bin/apropos -> whatis
-rwxr-xr-x 1 root root 48104 Aug  5  2018 /usr/bin/whatis" \
	]
}
