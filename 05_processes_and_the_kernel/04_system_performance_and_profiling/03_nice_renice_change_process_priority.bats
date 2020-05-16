#!/usr/bin/env bats

@test "test" {
	# nice <command>
	# nice -n (--n) <command>

    # nice numbers run from -20 to 20, with the default being 0. 

    # If you're not familiar with Unix, you will find its definition of priority confusing — it's the opposite of what you would expect. A process with a high nice number runs at low priority, getting relatively little of the processor's attention; similarly, jobs with a low nice number run at high priority. This is why the nice number is usually called niceness: a job with a lot of niceness is very kind to the other users of your system (i.e., it runs at low priority), while a job with little niceness hogs the CPU.

    # nice -6 awk -f proc.awk datafile > awk.out
    # nice --6 awk -f proc.awk datafile > awk.out

    # The first command runs awk with a high nice number (i.e., 6). The second command, which can be issued only by a superuser, runs awk with a low nice number (i.e., -6). If no level is specified, the default argument is -10.


    # once a job is running, you can use the renice command to change the job's priority:

    # renice priority -p pid
    # renice priority -g pgrp
    # renice priority -u uname

    # pgrp is the number of a process group, this command modifies the priority of all commands in a process group
    # uname may be a user's name, as shown in /etc/passwd; this form of the command modifies the priority of all jobs submitted by the user
}
