#!/usr/bin/env bats

@test "test who" {
	run who
	echo -e "# These users are on: " >&3
	for line in ${lines[@]}; do
		echo "# $line" >&3
		[[ "$line" =~ [a-zA-Z]+[[:space:]]*[pts/|:][0-9]+[[:space:]]+[0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]]+[0-9]{2}:[0-9]{2}.*$ ]]
	done
}
