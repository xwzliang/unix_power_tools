#!/usr/bin/env bats

@test "test" {
	sleep 100 &
	sleep 200 &
	run jobs
	expect=$(cat <<- _EOF_
	[1]-  Running                 sleep 100 &
	[2]+  Running                 sleep 200 &
	_EOF_
	)
	[ "$output" == "$expect" ]

    # The version of killall we're talking about here accepts multiple process-name arguments on its command line. Without its -i option, the command sends a signal (by default, TERM ) to any process name that matches. The process name you give has to match completely. Unfortunately, killall sends a signal to any process with that name — even processes owned by other users, which you can't kill (unless you're the superuser); you'll get the error Operation not permitted.

	killall sleep
	run jobs
	[ "$output" == "" ]

    # With -i, killall lists the PID number and gives you a choice of typing y to kill a process or n to leave it alone
    # Many systems have a command named killall with a -i ("interactive") option. Be careful, though, because there are several versions, and the most basic does just what it says: kills all processes on the system (when run as the superuser). Check killall's manual page on your system.
}
