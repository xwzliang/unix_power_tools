#!/usr/bin/env bats

@test "test" {
	# cron allows you to schedule programs for periodic execution. For example, you can use cron to call rsync every hour to update your production web site with new articles or to perform any number of other tasks.

    # crontab entries direct cron to run commands at regular intervals. Each one-line entry in the crontab file has the following format:

    # mins hrs day-of-month month weekday username cmd
    # (BSD)
    # mins hrs day-of-month month weekday cmd
    # (other)

    # The first five fields specify the times at which cron should execute cmd
    # crontab entry time fields

    # Field Meaning Range

    # mins The minutes after the hour 0-59
    # hrs The hour of the day 0-23 (0 = midnight)
    # day-of-month The day within a month 1-31
    # month The month of the year 1-12
    # weekday The day of the week 1-7 (1 = Monday) BSD  
    # 0-6 (0 = Sunday) System V

    # These fields can contain a single number, a pair of numbers separated by a dash (indicating a range of numbers), a comma-separated list of numbers and ranges, or an asterisk (*, a wildcard that represents all valid values for that field). Some versions accept strings of letters: for instance, Vixie cron, at least, accepts month and day names instead of numbers.

       # Instead of the first five fields, one of eight special strings may appear:

       #        string         meaning
       #        ------         -------
       #        @reboot        Run once, at startup.
       #        @yearly        Run once a year, "0 0 1 1 *".
       #        @annually      (same as @yearly)
       #        @monthly       Run once a month, "0 0 1 * *".
       #        @weekly        Run once a week, "0 0 * * 0".
       #        @daily         Run once a day, "0 0 * * *".
       #        @midnight      (same as @daily)
       #        @hourly        Run once an hour, "0 * * * *".

    # cron jobs are run by a system program in an environment that's much different from your normal login sessions. The search path is usually shorter; you may need to use absolute pathnames for programs that aren't in standard system directories. Be careful about using command aliases, shell functions and variables, and other things that may not be set for you by the system.

    # One problem with the crontab syntax is that it lets you specify any day of the month and any day of the week; but it doesn't let you construct cases like "the third Monday of every month." You might think that the crontab entry:
    # 12 5 15-21 * 1 your-command
    # would do the trick, but it won't; this crontab entry runs your command on every Monday, plus the 15th through the 21st of each month. 
    # The answer is to use the test and date commands to compare the name of today (like Tue) to the day we want the entry to be executed (here, Mon). This entry will be run between the 15th and 21st of each month, but the mtg-notice command will run only on the Monday during that period
    # 12 5 15-21 * * test `date +\%a` = Mon && /usr/local/etc/mtg-notice
    # or "backwards" way so the cron job's exit status would be 0 (success) in the case when it doesn't execute mtg-notice
    # 12 5 15-21 * * test `date +\%a` != Mon || /usr/local/etc/mtg-notice

    # Multiline std input for cron entry
    # cron allows you to include standard input directly on the command line. If the command contains a percent sign (%), cron uses any text following the sign as standard input for cmd. Additional percent signs can be used to subdivide this text into lines.
    # 30 11 31 12 * /etc/wall%Happy New Year!%Let's make next year great!
    # runs the wall command at 11:30 a.m. on December 31, using the text:
    # Happy New Year!
    # Let's make next year great!
    # as standard input. [If you need a literal percent sign in your entry, for a command like date +%a, escape the percent sign with a backslash: \%]


    # Use crontab to manage cron entries

    # list current user's cron entries
    crontab -l

    # Use editor to edit current user's entries
    # crontab -e

    # Use a file's contents as current user's cron entries
    # crontab <the-file>

    # Remove all current user's crontab entries
    # crontab -r
}
