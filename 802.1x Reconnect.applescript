-- ##########################################
-- # Copyright (c) 2015 University of Utah Student Computing Labs.
-- # All Rights Reserved.
-- #
-- # Permission to use, copy, modify, and distribute this software and
-- # its documentation for any purpose and without fee is hereby granted,
-- # provided that the above copyright notice appears in all copies and
-- # that both that copyright notice and this permission notice appear
-- # in supporting documentation, and that the name of The University
-- # of Utah not be used in advertising or publicity pertaining to
-- # distribution of the software without specific, written prior
-- # permission. This software is supplied as is without expressed or
-- # implied warranties of any kind.
-- ##########################################

-- ##########################################
-- # 802.1x Reconnect
-- #
-- # This script attempts to address an issue with Mac OS X "Yosemite" 10.10+ and 802.1X connections dropping.
-- #
-- # On launch it will open the System Preferences panel, navigate to the Network pane, find the Wi-Fi section and click the 802.1X connect button. Exiting if already connected.
-- #
-- # If you use this script as an application, you will need to add it to System Preferences:Security & Privacy:Accessibility to operate correctly.
-- #
-- # 0.1.0	2015.08.05	Initial version. tjm
-- # 0.1.1	2015.08.27	Added additional error checking and notification. tjm
-- #
-- ##########################################

-- ##########################################
-- # Notes:
-- #
-- #
-- #
-- #
-- ##########################################

display notification "Please wait." with title "Preferred network offline, reconnecting..."

tell application "System Preferences"
	-- open System Preferences and find Network panel
	reveal pane id "com.apple.preference.network"
end tell

tell application "System Events"
	tell application process "System Preferences"
		set frontmost to true
		-- focus on Network pane
		tell window "Network"
			set x to 1
			set headline to ""
			--search left-hand column to find Wi-Fi section
			repeat while headline is not equal to "Wi"
				set headline to (first word of (get value of static text 1 of row x of table 1 of scroll area 1)) as string
				set x to x + 1
			end repeat
			
			-- If script launched on non-WiFi equipped box, clean up and exit.		
			if headline is not equal to "Wi" then
				try
					tell application "System Preferences" to quit
				end try
				
				return
			end if	
			
			--select the column item when found
			select row (x - 1) of table 1 of scroll area 1
			
			-- If not configured for 802.1x, clean up and exit.
			try
				set buttonLabel to (get title of button 2 of group 1) as string
			on error
				try
					tell application "System Preferences" to quit
				end try
				
				return
			end try
			
			-- Don't click if already connected!
			if buttonLabel is not equal to "Disconnect" then
				-- click the button!
				click button 2 of group 1
			end if
			
		end tell
	end tell
end tell

-- quit and close window when finished
if application "System Preferences" is running then
	tell application "System Preferences" to quit
end if
