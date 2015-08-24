#802.1x Reconnect
========================

This script attempts to address an issue with Mac OS X "Yosemite" 10.10+ and 802.1X connections dropping.
## Contents

* [Download](#download) - get the script
* [Contact](#contact) - how to reach us
* [Purpose](#purpose) - what is this script for?
* [Usage](#usage) - details of invocation

## Download

[Download the latest version of 802.1x Reconnect here!](../../releases/)


## Contact

If you have any comments, questions, or other input, either [file an issue](../../issues) or [send an email to us](mailto:mlib-its-mac-github@lists.utah.edu). Thanks!

## Purpose
In Mac OS X 10.10 "Yosemite" there exists an issue where an 802.1x connection will not automatically reconnect upon wake from sleep. This is a widely reported issue<sup>[1](#myfootnote1)</sup> <sup>[2](#myfootnote2)</sup>, but there doesn't appear to be a fix forthcoming from Apple.

The most direct workaround we have found is to manually click the `Connect` button in the Wi-Fi pane of the Network System Preference. This script automates these actions for the user.

<a name="myfootnote1"></a>https://jamfnation.jamfsoftware.com/30.0b6/discussion.html?id=14693<br>
<a name="myfootnote2"></a>https://groups.google.com/forum/#!topic/macenterprise/74PiO9hrve4

## Usage
Depending on how you make use of the parts of this project, you will need to add them to the `Privacy` portion of the `Accessibility` pane of `Security & Privacy` in `System Preferences`. This is required for scripts to modify the users UI.

Our suggested usage is to make this script available to the user in a convenient location for them, ie the dock. Saving the script as an Application allows for locally customizing the app's icon, etc.

I've included the genericized pieces of our automated solution. We use crankd to detect changes in Wi-fi and launch a script to check for additional conditions before launching the AppleScript.


