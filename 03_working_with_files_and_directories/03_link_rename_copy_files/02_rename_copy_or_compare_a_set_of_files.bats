#!/usr/bin/env bats

@test "rename copy or compare a set of files" {
	rm -rf tmp
	mkdir tmp 
	cd tmp
	touch {1..3}.new

	# To copy or compare, just replace mv with cp or diff
	ls -d *.new | sed 's/\(.*\)\.new$/mv "&" "\1.old"/' | sh

	run ls
	[ "$output" == "$(echo -e "1.old\n2.old\n3.old\n")" ]

	
	## rename interactively using vim
	# vim
	# Start vi without a filename
	# :r !ls *.new
	# Read in the list of files, one filename per line
	# :%s/.*/mv -i & &/
	# Make mv command lines
	# :%s/new$/old/
	# Change second filenames; ready to review
	# :w !sh
	# Run commands by writing them to a shell
	# :q!
	# Quit vi without saving
}
