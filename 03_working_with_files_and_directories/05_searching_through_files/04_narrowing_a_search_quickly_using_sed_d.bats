#!/usr/bin/env bats

@test "narrowing down search quickly" {
	expect=$(cat <<- _EOF_
	agrep
	grepdiff
	lzegrep
	lzfgrep
	lzgrep
	msggrep
	pgrep
	ptargrep
	rgrep
	xzegrep
	xzfgrep
	xzgrep
	zipgrep
	_EOF_
	)
	output=$(ls /usr/bin | grep "grep")
	[ "$output" == "$expect" ]

	# Use sed -e /pattern/d to narrow down the search (especially the results in previous search are large)
	expect=$(cat <<- _EOF_
	agrep
	grepdiff
	lzegrep
	lzfgrep
	lzgrep
	msggrep
	pgrep
	ptargrep
	rgrep
	zipgrep
	_EOF_
	)
	output=$(ls /usr/bin | grep "grep" | sed -e /^x/d)
	[ "$output" == "$expect" ]

	expect=$(cat <<- _EOF_
	agrep
	grepdiff
	msggrep
	pgrep
	ptargrep
	rgrep
	zipgrep
	_EOF_
	)
	output=$(ls /usr/bin | grep "grep" | sed -e /^x/d -e /^lz/d)
	[ "$output" == "$expect" ]

	expect=$(cat <<- _EOF_
	agrep
	grepdiff
	msggrep
	rgrep
	zipgrep
	_EOF_
	)
	output=$(ls /usr/bin | grep "grep" | sed -e /^x/d -e /^lz/d -e /^p/d)
	[ "$output" == "$expect" ]
}
