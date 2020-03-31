#!/usr/bin/env bats

@test "test" {
	sleep 1 &
	run echo $!
	# $output is PID, exp: 2058
	[[ "$output" =~ [0-9]+ ]]

	sleep 2 &
	run jobs
	# Every background process is assigned a job number by your shell. This number is unique only for your current session
	expect=$(cat <<- _EOF_
	[1]-  Running                 sleep 1 &
	[2]+  Running                 sleep 2 &
	_EOF_
	)
	[ "$output" == "$expect" ]

	# kill the job numbered 1
	kill %1
	expect=$(cat <<- _EOF_
	[2]+  Running                 sleep 2 &
	_EOF_
	)
	run jobs
	[ "$output" == "$expect" ]
	# If you want to stop the process rather than killing it, use:
	# kill -STOP %1

	run kill %2
	[ "$output" == "" ]
	run jobs
	[ "$output" == "" ]


	# the job control mechanism uses a simple pattern-matching scheme so that you can supply only part of the command or job you wish to foreground or kill. Instead of prefixing the job number with simply %, use %?
	sleep 2 &
	ls &
	run jobs
	expect=$(cat <<- _EOF_
	[1]-  Running                 sleep 2 &
	[2]+  Running                 ls &
	_EOF_
	)
	[ "$output" == "$expect" ]

	kill %?sle
	run jobs
	# ls has finished.
	expect=$(cat <<- _EOF_
	[2]   Done                    ls
	_EOF_
	)
	[ "$output" == "$expect" ]

}
