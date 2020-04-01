#!/usr/bin/env bats

@test "test" {
	# In the C shell, processes that you run in the background are immune to hangups, but in the Bourne shell, a process that you started in the background might be abruptly terminated. The nohup command ("no hangup") allows you to circumvent this.
	nohup sleep 1 &
	kill %1

	# Another way to keep process running is to run a job without job control
	# the trick in most shells is to start the job in a subshell, and put the job inside that subshell into the background. This is sometimes called "disowning" the job. Note that the ampersand (&) is inside the parentheses
	(sleep 2 &)
	run jobs
	# The job won't appear in the jobs list
	[ "$output" == "" ]

	# but ps will show it running
	ppid=$(ps -l | grep sleep | awk '{print $5}')
	pid=$(ps -l | grep sleep | awk '{print $4}')

	# ps -l output looks like following (PPID) is the id of parent process:
	# F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
	# 0 S  1000 14555 22607  0  80   0 -  3136 do_wai pts/19   00:00:00 bash

	# echo "# $output" >&3

	# PPID is 1, this means that the process is now "owned" by init
	[ "$ppid" == "1" ]

	kill $pid
	# if you'd started the job in the background normally (without the subshell trick), you'd see that its PPID was that of the shell you started it from.
	sleep 2 &
	ppid=$(ps -l | grep sleep | awk '{print $5}')
	pid=$(ps -l | grep sleep | awk '{print $4}')
	[[ $ppid > "1" ]]

	kill $pid
	# In zsh and bash Version 2, though, you can change your mind after you start a job by using the shell's built-in disown command. Give disown the job number you want the shell to "forget."
	sleep 2 &
	run jobs
	expect=$(cat <<- _EOF_
	[1]+  Running                 sleep 2 &
	_EOF_
	)
	[ "$output" == "$expect" ]

	disown %1
	# It disappears from the job table
	run jobs
	[ "$output" == "" ]
	# but ps will show it running, and PPID is not 1
	ppid=$(ps -l | grep sleep | awk '{print $5}')
	pid=$(ps -l | grep sleep | awk '{print $4}')
	[[ $ppid > "1" ]]
	kill $pid

}
