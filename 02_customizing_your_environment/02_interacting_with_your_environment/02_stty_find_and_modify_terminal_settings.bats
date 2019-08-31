#!/usr/bin/env bats

@test "test stty" {
	tty_settings=$(cat <<- _EOF_
		speed 38400 baud; rows 46; columns 151; line = 0;
		intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>;
		eol2 = <undef>; swtch = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R;
		werase = ^W; lnext = ^V; discard = ^O; min = 1; time = 0;
		-parenb -parodd -cmspar cs8 -hupcl -cstopb cread -clocal -crtscts
		-ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr icrnl ixon -ixoff
		-iuclc -ixany -imaxbel iutf8
		opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
		isig icanon iexten echo echoe echok -echonl -noflsh -xcase -tostop -echoprt
		echoctl echoke -flusho -extproc
_EOF_
)
	# Show all settings in terminal
	run stty -a
	for line in ${lines[@]}; do
		echo "# $line" >&3
	done
	[[ "$output" == "$tty_settings" ]]

	# Modify tty settings for erase--if actually needed, run interactively in shell
	setting_erase="erase = \^H"
	run stty erase ^h
	[[ "$(stty -a)" =~ $setting_erase ]]
}
