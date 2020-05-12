#!/usr/bin/env bats

@test "test" {
	# The kill command doesn't kill — it really does nothing more than send signals.

	# Signals are a simple but important means of interprocess communication. Interprocess communication sounds fancy, but it's really a simple concept: it's the means by which one program sends a message to another program. It's common to think of signals as special messages sent by the Unix kernel but, in fact, any program can signal any other program.

	# Common signals (Use kill -l for a list of signal names)

	# name Number Meaning and typical use

	# HUP 1 Hangup — stop running. Sent when you log out or disconnect a modem.
	# INT 2 Interrupt — stop running. Sent when you type CTRL-c.
	# QUIT 3 Quit — stop running (and dump core). Sent when you type CTRL-\.
	# KILL 9 Kill — stop unconditionally and immediately; a good "emergency kill."
	# SEGV 11 Segmentation violation — you have tried to access illegal memory.
	# TERM 15 Terminate — terminate gracefully, if possible.
	# STOP 17* Stop unconditionally and immediately; continue with CONT.
	# TSTP 18* Stop — stop executing, ready to continue (in either background or foreground). Sent when you type
	# CTRL-z. stty calls this susp.
	# CONT 19* Continue — continue executing after STOP or TSTP.
	# CHLD 20* Child — a child process's status has changed.

	# When you type CTRL-c, you're sending the INT (interrupt) signal to the foreground process.
	# the command kill -9 is guaranteed to kill a process. Why? Two special signals in Table can't be caught or ignored: the KILL and STOP signals.
	# The default signal of kill is number 15, the TERM signal, which tells the process to terminate.

	sleep 1 &
	sleep 2 &
	run jobs
	# for line in "${lines[@]}"; do
	# 	echo "# $line" >&3
	# done
	expect=$(cat <<- _EOF_
	[1]-  Running                 sleep 1 &
	[2]+  Running                 sleep 2 &
	_EOF_
	)
	[ "$output" == "$expect" ]

	kill -KILL %1
	expect=$(cat <<- _EOF_
	[2]+  Running                 sleep 2 &
	_EOF_
	)
	run jobs
	[ "$output" == "$expect" ]

	# executing the kill command with the -KILL or -9 option both send the same signal, namely, KILL
	kill -9 %2
	run jobs
	[ "$output" == "" ]

	# If you want to stop the process rather than killing it, use:
	# kill -STOP %1

	# On many Unix systems, kill interprets the special "process ID" -1 as a command to signal all your processes (all processes with your user ID), except for the process sending the signal. For example, the following command will terminate all your processes
	# kill -TERM -1
    # So be careful!

    # The special -1 process ID is defined differently for the superuser; if you're root, it means "all processes except system processes."
}
