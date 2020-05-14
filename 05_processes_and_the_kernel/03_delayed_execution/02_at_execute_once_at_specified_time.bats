#!/usr/bin/env bats

@test "test" {
    # Unlike cron, which let us run a task on a regular basis, at gives us the ability to execute a command or a script at a specified date and hour, or after a given interval of time. Minutes, hours, days or weeks can be used as units. It's even possible to use certain "keywords" as midnight or teatime (which corresponds to 4pm). 

    # Let's suppose we want to run a command 1 minute from now. The correct syntax would be:
    # at now + 1 minute

    # Once the above line is executed, the at prompt will appear, waiting for us to enter the command to be executed after the specified time interval:
    # $ at now + 1 minutes
    # at> echo "Hello world" > test.txt
    # at> 
    # job 4 at Tue Dec 19 11:29:00 2017

    # To exit the at prompt we should press the CTRL+d key combination. At this point we will presented with a summary of the scheduled task, which will show us the job id (4 in this case) and the date at which it will be executed. 

    # Run script file or run command using redirection
    # at now + 1 minute -f script.sh
    # at now + 1 minute <<<"sleep 1000"

    # list current scheduled tasks
    # atq

    # remove task (job id)
    # atrm 4


    # Examples of at Command:

    # Schedule task at coming 10:00 AM.
    # at 10:00 AM

    # Schedule task at 10:00 AM on coming Sunday.
    # at 10:00 AM Sun

    # Schedule task at 10:00 AM on coming 25’th July.
    # at 10:00 AM July 25

    # Schedule task at 10:00 AM on coming 22’nd June 2015.
    # at 10:00 AM 6/22/2015
    # at 10:00 AM 6.22.2015

    # Schedule task at 10:00 AM on the same date at next month.
    # at 10:00 AM next month

    # Schedule task at 10:00 AM tomorrow.
    # at 10:00 AM tomorrow

    # Schedule task at 10:00 PM tomorrow.
    # at 10:00 PM tomorrow

    # Schedule task to execute just after 1 hour.
    # at now + 1 hour

    # Schedule task to execute just after 30 minutes.
    # at now + 30 minute
    # at now + 30 minutes

    # Schedule task to execute just after 1 and 2 weeks.
    # at now + 1 week
    # at now + 2 weeks

    # Schedule task to execute just after 1 and 2 years.
    # at now + 1 year
    # at now + 2 years

    # Schedule task to execute at midnight.
    # at midnight
    # The above job will execute on next 12:00 AM
}
