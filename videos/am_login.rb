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

# Activity Manager opens their email

# Clicks on the access key for a new activity
launch 'Safari', at(100, 50, 1024, 768)
pause 3
url 'http://192.168.0.2:3000/cc533d9de98744a379c47b8df037242c6738ed4f'

pause 4

# Move to drop-down
move to_element('#activity_ces_question')
pause 1

highlight do
  pause 3
  # Answer CES question 'No'
  drag by(0, 30)
  
  # Pause a bit
  pause 3

  # Click on the submit button
  move to_element('#next_button')
  pause 1
  click
end

# Go to the activity type page
pause 3

# Move to drop-down
move to_element('#activity_function_policy')
pause 1

highlight do
  pause 3  
  # Select existing function
  drag by(0, 15)
  
  # Pause a bit
  pause 1
    
  move to_element('#activity_existing_proposed')
  pause 1
  drag by(0, 15)
  
  # Pause a bit
  pause 3  

  move to_element('#save_activity_type_button')
  pause 1
  click
end

# Wait for the page to load
pause 5