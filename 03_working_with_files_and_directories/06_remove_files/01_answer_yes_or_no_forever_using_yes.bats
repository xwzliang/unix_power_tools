#!/usr/bin/env bats

@test "yes" {
	rm -rf tmp
	mkdir tmp
	cd tmp
	touch file{1..5}


	# rm -i will ask user's input for every file to be deleted
	# yes will answer y forever by default
	yes | rm -i file*

	for i in file*; do
		[ ! -e $i ]
	done


	# yes n will answer n forever. Actually, yes will output following string argument forever, yes hello will output hello forever
	touch file{1..5}

	yes n | rm -i file*

	for i in file*; do
		[ -e $i ]
	done
}
