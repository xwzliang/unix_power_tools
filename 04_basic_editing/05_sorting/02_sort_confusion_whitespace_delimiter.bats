#!/usr/bin/env bats

@test "sort sonfusion whitespace" {

	test_string=$(cat << _EOF_
	apple	Fruit shipment
20	beta	beta test sites
aza	beta	beta test sites
 5		alpha or other
_EOF_
)

	run cat -A <<< $test_string
	expect=$(cat << _EOF_
^Iapple^IFruit shipment$
20^Ibeta^Ibeta test sites$
aza^Ibeta^Ibeta test sites$
 5^I^Ialpha or other$
_EOF_
)
	[ "$output" == "$expect" ]


	run sort <<< $test_string
	expect=$(cat << _EOF_
20	beta	beta test sites
 5		alpha or other
	apple	Fruit shipment
aza	beta	beta test sites
_EOF_
)
	# The leading whitespaces are ignored
	[ "$output" == "$expect" ]

	run sort +1 <<< $test_string
	expect=$(cat << _EOF_
 5		alpha or other
20	beta	beta test sites
aza	beta	beta test sites
	apple	Fruit shipment
_EOF_
)
	# the two tabs are treated as one
	[ "$output" == "$expect" ]
}
