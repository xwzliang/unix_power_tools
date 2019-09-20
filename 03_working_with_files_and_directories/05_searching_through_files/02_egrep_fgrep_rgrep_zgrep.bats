#!/usr/bin/env bats

@test "egrep fgrep rgrep zgrep" {
	# egrep fgrep rgrep, these variants are deprecated, but are provided for backward compatibility.

	# egrep is equivalent to grep -E, --extended-regexp
	expect=$(cat <<- _EOF_
	gzexe.1.gz
	gzip.1.gz
	zip.1.gz
	zipcloak.1.gz
	zipdetails.1.gz
	zipgrep.1.gz
	zipinfo.1.gz
	zipnote.1.gz
	zipsplit.1.gz
	_EOF_
	)
	output=$(ls /usr/share/man/man1 | egrep "^(gz|zip)") 
	[ "$output" == "$expect" ]

	# fgrep is equivalent to grep -F, --fixed-strings. Pattern is treated as fixed strings instead of regular expression
	expect=$(cat <<- _EOF_
	funzip.1.gz
	gpg-zip.1.gz
	gunzip.1.gz
	gzip.1.gz
	mzip.1.gz
	p7zip.1.gz
	preunzip.1.gz
	prezip.1.gz
	unzip.1.gz
	zip.1.gz
	_EOF_
	)
	output=$(ls /usr/share/man/man1 | fgrep "zip.1") 
	[ "$output" == "$expect" ]

	# rgrep is equivalent to grep -r, --recursive
	run rgrep version /usr/share/man
	[ "$output" == "/usr/share/man/man1/vncinitconfig.1:depending upon the version of PAM installed, to enable system" ]

	# zgrep is used to grep from compressed file
	run zgrep 'egrep, fgrep, rgrep' /usr/share/man/man1/egrep.1.gz
	[ "$output" == "grep, egrep, fgrep, rgrep \- print lines matching a pattern" ]
}
