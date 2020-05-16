#!/usr/bin/env bats

@test "test" {
	uptime

    # 12:35:15 up 2 days, 21:00,  3 users,  load average: 0.15, 0.06, 0.02

    # The load average is a rough measure of CPU use. These three figures report the average number of processes active during the last minute, the last 5 minutes, and the last 15 minutes.
}
