#!/usr/bin/env python

# Sends an email with the IP of the Pi
# Add to /etc/rc.local to run on boot:
# /path/to/scripts/boot_mailer.py /path/to/config

import subprocess
import smtplib
import socket
from email.mime.text import MIMEText
import datetime
import ConfigParser
import sys
import syslog

# grab the config file from command line arguments
if len(sys.argv) > 1:
	config_file = sys.argv[1]
else:
	sys.stderr.write("Please supply the location of the config file.")
	syslog.syslog('No configuration file supplied.')
	exit(1)

# parse config file
config = ConfigParser.ConfigParser()
parsed_files = config.read(config_file)

# get from config file
try:
	to             = config.get('email', 'to')
	email_user     = config.get('email', 'login')
	email_password = config.get('email', 'password')
	smtp_server    = config.get('email', 'smtp_server')
	smtp_port      = config.getint('email', 'smtp_port')
except Exception as e:
	sys.stderr.write("Config File Error: " + e.strerror)
	syslog.syslog("Config File Error: " + e.strerror)
	exit(1)

# smtp login
smtpserver = smtplib.SMTP(smtp_server, smtp_port)
smtpserver.ehlo()
smtpserver.starttls()
smtpserver.ehlo
smtpserver.login(email_user, email_password)
today = datetime.date.today()

# get IP
arg = 'ip route list'
p = subprocess.Popen(arg,shell=True,stdout=subprocess.PIPE)
data = p.communicate()
split_data = data[0].split()
ipaddr = split_data[split_data.index('src')+1]
my_ip = 'IP is %s' %  ipaddr

# construct and send
msg = MIMEText(my_ip)
msg['Subject'] = 'IP For RaspberryPi on %s' % today.strftime('%b %d %Y')
msg['From'] = email_user
msg['To'] = to
smtpserver.sendmail(email_user, [to], msg.as_string())
smtpserver.quit()

syslog.syslog('Email with IP address sent to ' + to)
