#!/usr/bin/env bats

@test "test mkdir -p" {
	[ ! -d $PWD/test ]
	dir_for_test=$PWD/test/01/02/03
	# mkdir -p will create parent directory if not existed
	run mkdir -p $dir_for_test
	[ -d $dir_for_test ]
	run rm -r test
}
