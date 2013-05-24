rpi-scripts
===========

Scripts for managing a Raspberry Pi

boot/boot_mailer.py
===================
Add this to your /etc/rc.local file to get an email with the IP each time the Pi boots up. Works great if your Pi gets a dynamic IP from your router.

Loads its settings from a config file. See config.example for options, and copy to a file named "config" to avoid overwriting your customizations when updating from the git repository.

cron/network_check.sh
=====================
Checks network connectivity and reboots if there are problems.

cron/uptime.sh
==============
Logs uptime and load average to /var/log/syslog. Useful for seeing historical CPU loads when network connectivity is spotty.