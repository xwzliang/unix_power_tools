#!/usr/bin/env bats

@test "test" {
	# & will put process in background
	sleep 1 &
	# If you're using Bourne-type shells, you have to watch out for putting a series of commands separated by semicolons into the background.
	sleep 1; ls &
	# In Bourne-like shells, you won't get your prompt back until the sleep command has finished.
	# the proper way to put a series of commands into the background is to group them with parentheses:
	(sleep 1; ls)&

	# In interactive shells:
	# bg -- put process to background
	# fg -- put process to foreground
	# typing CTRL-z -- suspend process
	# type bg after suspending process will put it to background and restart it

	# % is the current stopped or background job, but not always the last one. If you've stopped any jobs, the current job is the most recently stopped job. Otherwise, it's the most recent background job. For example, try stopping your editor (like vi), then putting another job in the background:
	# % vi afile
	# CTRL-z
	# Stopped
	# % sleep 1000 &
	# [2] 12345
	# % fg
	# and notice that the fg brings your editor to the foreground.

	# If you put a job in the background and don't redirect its output, text that the job writes to its standard output and standard error comes to your screen. Those messages can mess up the screen while you're using another program. You could lose the (maybe important) messages, too — they might scroll off your screen and be lost, or your foreground program may clear the screen and erase them.
	stty tostop
	# Many Unix systems have the command stty tostop. Type that command at a prompt, or put it in your .login or .profile file. After that, your shell's background jobs that try to write to your terminal will be stopped. When you want to see the background job's output, bring it into the foreground (with fg).

}
