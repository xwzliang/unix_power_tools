#!/usr/bin/env  bats

@test "ln linking" {
	rm -rf tmp
	mkdir tmp
	cd tmp
	mkdir dir1 dir2
	cd dir1
	touch file file_other
	ln file hardlink
	ln -s file symlink

	inode_num_file=`ls -i file | awk '{print $1}'`
	inode_num_hardlink=`ls -i hardlink | awk '{print $1}'`
	inode_num_symlink=`ls -i symlink | awk '{print $1}'`
	# Hard link file has the same inode number as the original, whereas symlink is different
	[ $inode_num_file == $inode_num_hardlink ]
	[ $inode_num_file != $inode_num_symlink ]

	cd ../dir2
	# If no destination specified, ln will create link in the current dir with the same file name as original
	ln -s ../dir1/file
	[ -f ./file ]
	# ls -l will show the original file location
	run ls -l file
	[[ "$output" =~ "file -> ../dir1/file" ]]

	mkdir subdir
	touch file1 file2
	# ln can also specify directory for destination
	ln file1 file2 subdir/
	# if symlink only specify directory will create broken links:
	ln -s ../dir1/file ../dir1/file_other subdir/
	[ -f ./subdir/file1 ]
	[ -f ./subdir/file2 ]

	# ls -Ll will show broken links
	run ls -Ll subdir
	[[ "$output" =~ "l????????? ? ?    ?    ?            ? file" ]]

	# using relative pathnames will let you move entire directory trees around without invalidating links (provided that both the file and the link are in the same tree).
	# using absolute pathnames is useful if you're more likely to move the link than the original file.
}
