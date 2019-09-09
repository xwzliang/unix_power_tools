#!/usr/bin/env  bash

# locate searches the "fast find" database which is usually rebuilt every night. So, it's not completely up-to-date, but it's usually close enough.
# locate returns absolute paths
locate bin
# Because locate is so fast, it's worth trying to use whenever you can. Pipe the output to xargs and any other Unix command, or run a shell or Perl script to test its output — almost anything will be faster than running a standard find.
ls -l `locate whatever`
locate whatever | xargs ls -ld
# The locate database may need to be updated on your machine before you can use locate, if it's not already in the system's normal cron scripts. Use locate.updatedb to do this, and consider having it run weekly or so if you're going to use locate regularly.


# The difference between the shell's wildcard matching and locate matching is that the shell treats slashes (/ ) in a special manner: you have to type them as part of the expression. In locate, a wildcard matches slashes and any other character. When you use a wildcard, be sure to put quotes around the pattern so the shell won't touch it.
# To find any pathname that ends with bin:
locate '*bin'
# To find any pathname that ends with /bin (a good way to find a file or directory named exactly bin):
locate '*/bin'
# To match the files in a directory named bin, but not the directory itself, try something like this:
locate '*/bin/*'
# locate asterisk matches dot files, unlike shell wildcards. So below command will match files in /home whose names end with a tilde (~) (these are probably backup files from the Emacs editor), including dot files
locate '/home/*~'
# find a path with four characters
locate '????'
# find a path in root which is four characters and the first is b or e or l
locate '/[bel]??'


# To build your own databases:
# find . -print | sed "s@^./@@" > .fastfind.new
# mv -f .fastfind.new .fastfind

# Or compress it to save space
# find . -print | sed "s@^./@@" | gzip > .fastfind.gz

# Then set up cron or at to run that find as often as you want

# Make a shell script:
# egrep "$1" $HOME/.fastfind | sed "s@^@$HOME/@"
# Or for a gzipped database
# gzcat $HOME/.fastfind.gz | egrep "$1" | sed "s@^@$HOME/@"
