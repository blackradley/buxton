#!/usr/bin/env castanaut

LIVE = (ARGV[0] == '-L') || false

plugin 'safari'
plugin "mousepose"
launch "Mousepose"

if LIVE
  plugin "ishowu"
  ishowu_set_region at(84, 34, 1056, 800)
  ishowu_start_recording
end

# Org Mgr log in to show the two tables with four activities,
# the ones currently in the Birmingham organisation, identified and none started.
launch 'Safari', at(100, 50, 1024, 768)
url 'http://192.168.0.2:3000/513e159835701a44c12f0035571d1cb90f5da693'

pause 4

# Click to activities page to show the list of the four activities.


# Show how Org Mgr can send a key.


# Click on sections page to show how Org Mgr can view questions that have been answered.