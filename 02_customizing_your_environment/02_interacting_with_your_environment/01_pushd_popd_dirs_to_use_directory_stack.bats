#!/usr/bin/env bats

@test "test pushd popd dirs" {
	cwd=`echo $PWD | sed "s:$HOME:~:g"`

	# Use dirs command to show the directory stack
	[ `dirs` == $cwd ]

	run bash -c "pushd /usr/bin && dirs"
	[ "${lines[1]}" == "/usr/bin $cwd" ]

	run bash -c "pushd /usr/bin && popd && dirs"
	for line in ${lines[@]}; do
		echo "# $line" >&3
	done
	[ "${lines[2]}" == "$cwd" ]
}
