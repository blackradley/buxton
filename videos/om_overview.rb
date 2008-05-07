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

pause 6

if LIVE
  ishowu_start_recording
  pause 4
end

# Click to activities page to show the list of the four activities.
move to_element('#menuBar ul li', :index => 1)
pause 3
click
move by(0, 30)
pause 3

# Show how Org Mgr can send a key.
move to_element('.actions a', :index => 1)
pause 3
click
pause 3
move to(815, 315)
pause 3
click
pause 4

# Click on sections page to show how Org Mgr can view questions that have been answered.
move to_element('#menuBar ul li', :index => 2)
pause 3
click
move by(0, 30)
pause 3