#!/usr/bin/env bats

@test "test readlink" {
	# readlink will return the original file path of the symlink
	run readlink $HOME/.bash_aliases
	expect="$HOME/git/dotfiles/bash_aliases.symlink"
	[ "$output" == "$expect" ]
	# readlink returns nothing for non-symlink
	run readlink $HOME/.bashrc
	[ "$output" == "" ]
}
