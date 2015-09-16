#!/bin/sh

##########################################
# Copyright (c) 2015 University of Utah Student Computing Labs.
# All Rights Reserved.
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby granted,
# provided that the above copyright notice appears in all copies and
# that both that copyright notice and this permission notice appear
# in supporting documentation, and that the name of The University
# of Utah not be used in advertising or publicity pertaining to
# distribution of the software without specific, written prior
# permission. This software is supplied as is without expressed or
# implied warranties of any kind.
##########################################

##########################################
# 802.1x check
#
# This script works together with the 802.1x reconnect AppleScript to address an
# issue with OSX 10.10 and 802.1x connection drops.
#
# This script can be run by itself, or launched from a crankd wireless event.
# It attempts to automatically reconnect without user intervention. System Preferences
# will flash on the users desktop, so some user education may be required.
# Additionally, you will need to add crankd to
# System Preferences:Security & Privacy:Accessibility for the script to operate correctly.
#
#	0.1.0	2015.08.24	Initial version. tjm
#	0.1.1	2015.09.11	Addressed an issue with crankd opening an extra system prefs. tjm
#
#
##########################################

##########################################
# Notes:
#
#
#
#
##########################################

# semaphore
redflag=/tmp/8021xcheck_running

# applescript filename
myscript="/path/to/802.1x Reconnect.app/Contents/Resources/Scripts/main.scpt"

# name of preferred wireless network
preferredNetwork="your 802.1x network"


# if semaphore exists, exit!
# if the semaphore exists, the script is already running.
# check to clean semaphore?
if /bin/test -e $redflag
then
# better message
	echo "bail out, already running. $(date)"
	exit 1
fi

# set the semaphore
touch $redflag

# which interface is Wi-Fi?
wifiDevice=$(/usr/sbin/networksetup -listallhardwareports | /usr/bin/grep Wi-Fi -w1 | /usr/bin/grep Device | /usr/bin/cut -d" " -f2)

# what network is the Wi-Fi pointed at?
wifiNetwork=$(/usr/sbin/networksetup -getairportnetwork "$wifiDevice" | /usr/bin/cut -d":" -f2 | /usr/bin/cut -d" " -f2)

# check for console user
# bail out if no console user
consoleCount=$(/usr/bin/who -q | /usr/bin/grep users | /usr/bin/cut -d"=" -f2 | /usr/bin/cut -d" " -f2)
if /bin/test "$consoleCount" -eq 0
then
	echo "bail out, no console user. $(date)"
	rm $redflag
	exit 1
fi

# check for administrative user
# bail out if
macUser=$(/usr/bin/users | /usr/bin/grep "Admin user")
if /bin/test $? -eq 0
then
	echo "bail out, admin user logged in. $(date)"
	rm $redflag
	exit 1
fi

# check if Finder running.
# bail out if not
finderUp=$(/usr/bin/pgrep Finder)
if /bin/test $? -eq 1
then
	echo "bail out, Finder not running. $(date)"
	rm $redflag
	exit 1
fi

# check if System Preferences already running.
# bail out if
prefsUp=$(/usr/bin/pgrep "System Preferences")
if /bin/test $? -eq 0
then
	theFrontmostApp=$(/usr/bin/osascript -e 'tell application "System Events" to set FrontAppName to name of first process where frontmost is true' -e 'return FrontAppName')
	if /bin/test "X$theFrontmostApp" = "XSystem Preferences"
	then
		echo "bail out, System Preferences is frontmost, in use? $(date)"
		rm $redflag
		exit 1
	fi
fi

# check if wi-fi powered on
# bail out if off
wirelessPower=$(/usr/sbin/networksetup -getairportpower "$wifiDevice" | /usr/bin/cut -d" " -f4)
if /bin/test "X$wirelessPower" = "XOff"
then
	echo "bail out, Wi-Fi off. $(date)"
	rm $redflag
	exit 1
fi

# check for preferred network
# bail if not
if /bin/test "X$wifiNetwork" != "X$preferredNetwork"
then
	echo "bail out, wrong network. $(date)"
	rm $redflag
	exit 1
fi

# feeling like there should be a pause before launching the script.
# prevents repeated clicking
sleep 8


/usr/bin/osascript $myscript


# normal completion
# better messages
# no email
echo "Normal exit. $(date)"
rm $redflag

prefsUp=$(/usr/bin/pgrep "System Preferences")
if /bin/test $? -eq 0
then
	theFrontmostApp=$(/usr/bin/osascript -e 'tell application "System Events" to set FrontAppName to name of first process where frontmost is true' -e 'return FrontAppName')
	if /bin/test "X$theFrontmostApp" != "XSystem Preferences"
	then
		/usr/bin/pkill "System Preferences"
	fi
fi

exit 0
