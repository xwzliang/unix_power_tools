#!/usr/bin/env bats

@test "uuencode uudecode" {
	# uuencode  - encode a file into email friendly text
	# uudecode  - decode an encoded file

	. mk_tmp_dir

	run uuencode filename <<< "hello, world"

	expect=$(cat <<- '_EOF_'
	begin 664 filename
	-:&5L;&\L('=O<FQD"@``
	`
	end
	_EOF_
	)
	[ "$output" == "$expect" ]

	uuencode filename <<< "hello, world" | uudecode
	run cat filename
	[ "$output" == "hello, world" ]

	# -o option in uudecode let you specify output filename, "-" for stdout
	output=$(uuencode filename <<< "hello, world" | uudecode -o-)
	[ "$output" == "hello, world" ]
}
