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
In Mac OS X 10.10 "Yosemite" there exists an issue where an 802.1x connection will not automatically reconnect upon wake from sleep. This is a widely known and reported issue, but there doesn't appear to be a fix forthcoming from Apple.[1]

The most direct workaround we have found is to manually click the `Connect` button in the Wi-Fi pane of the Network System Preference. This script automates these actions for the user.

[1]: https://jamfnation.jamfsoftware.com/30.0b6/discussion.html?id=14693

## Usage
Our suggested usage is to make this script available to the user in a convenient location for them, ie the dock. Saving the script as an Application allows for locally customizing the app's icon, etc.
