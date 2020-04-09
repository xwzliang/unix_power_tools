#!/usr/bin/env bats

@test "test" {
	# The ps command produces a report summarizing execution statistics for current processes. The bare ps command lists the process ID, the terminal from which the command was started, how much CPU time it has used, and the command itself. The output looks something like this
	# Processes without a controlling terminal show a question mark (?).
	#   PID TTY          TIME CMD
	# 2140 ?        00:03:05 systemd
	output=$(ps | head -1)
	expect=$(cat << _EOF_
  PID TTY          TIME CMD
_EOF_
)
	[ "$output" == "$expect" ]

	# Under BSD Unix, the command is ps -aux, which produces a table of all processes, arranged in order of decreasing CPU usage at the moment when the ps command was executed. [The -a option gives processes belonging to all users, -u gives a more detailed listing, and -x includes processes that no longer have a controlling terminal
# USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
# root         1  0.0  0.1 168712 11304 ?        Ss   Mar25   0:29 /sbin/init splash
# someuser   334  0.0  1.1 289860 88676 pts/16   Sl+  Apr05   2:54 /usr/bin/emacs -nw
	output=$(ps aux | head -1)
	expect=$(cat << _EOF_
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
_EOF_
)
	[ "$output" == "$expect" ]

	# A vaguely similar listing is produced by the System V ps -ef command:
# UID        PID  PPID  C STIME TTY          TIME CMD
# root         1     0  0 Mar25 ?        00:00:29 /sbin/init splash
	output=$(ps aux | head -1)
	expect=$(cat << _EOF_
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
_EOF_
)
	[ "$output" == "$expect" ]

	# ps -l (long format)
# F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
# 4 S  1000  2140     1  0  80   0 -  4762 ep_pol ?        00:03:05 systemd
	output=$(ps aux | head -1)
	expect=$(cat << _EOF_
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
_EOF_
)
	[ "$output" == "$expect" ]

	# USER (BSD) Username of process owner

	# UID (System V) User ID of process owner

	# PID Process ID

	# %CPU Estimated fraction of CPU consumed (BSD)

	# %MEM Estimated fraction of system memory consumed (BSD)

	# SZ Virtual memory used in K (BSD) or pages (System V)

	# RSS Real memory used (in same units as SZ)

	# TT, TTY Terminal port associated with process

	# STAT (BSD), S (System V) Current process state; one (or more under BSD) of:
		# R: Running or runnable 
		# S: Sleeping 
		# I: Idle (BSD); intermediate state (System V) 
		# T: Stopped
		# Z: Zombie process
		# D (BSD): Disk wait 
		# P (BSD): Page wait 
		# X (System V): Growing,waiting for memory 
		# K (AIX): Available kernel process 
		# W (BSD): Swapped out 
		# N (BSD): Niced, execution priority lowered 
		# > (BSD): Execution priority artificially raised
	# TIME Total CPU time used

	# COMMAND Command line being executed (may be truncated)

	# STIME (System V) Time or date process started

	# C (System V), CP (BSD) Short term CPU-use factor; used by scheduler for computing execution priority (PRI below)

	# F Flags associated with process (see ps manual page)

	# PPID Parent's PID

	# PRI Actual execution priority (recomputed dynamically)

	# NI Process nice number

	# WCHAN Event process is waiting for
}
