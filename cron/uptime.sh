#!/bin/sh

# keep track of the uptime and load average in /var/log/syslog

# place in cron to check every 5 minutes:
# */5 * * * *    root    /path/to/uptime.sh >/dev/null

logger $(uptime)