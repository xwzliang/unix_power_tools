#!/usr/bin/env bats

@test "test" {
    # Usually shell has builtin time function

	# /usr/bin/time <command>

    # 0.02user 0.01system 0:01.17elapsed 3%CPU (0avgtext+0avgdata 12264maxresident)k
    # 0inputs+0outputs (0major+2780minor)pagefaults 0swaps

    # on behalf of the user (user time)
    # on behalf of the system (system time)
    # Elapsed time is the wall clock time from the moment you enter the command until it terminates, including time spent waiting for other users, I/O time, etc. By definition, the elapsed time is greater than your total CPU time and can even be several times larger.
}
