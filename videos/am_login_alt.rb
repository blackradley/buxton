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

# Act Mgr log in for ‘Develop service user engagement strategy’
launch 'Safari', at(100, 50, 1024, 768)
url 'http://192.168.0.2:3000/cc533d9de98744a379c47b8df037242c6738ed4f'

pause 4

# Click no for CES question and then click on link to CES.
move to_element('#activity_ces_question')
pause 1

highlight do
  pause 2
  # Answer CES question 'No'
  drag by(0, 20)
  
  # Pause a bit
  pause 2

  # Click on the submit button
  move to_element('#next_button')
  pause 1
  click
end

pause 3

# Click next, then Policy, then Proposed, then save, show section 2 appearing.
move to_element('#activity_function_policy')
pause 1

highlight do
  pause 2  
  # Select proposed policy
  drag by(0, 20)
  
  # Pause a bit
  pause 1
    
  move to_element('#activity_existing_proposed')
  pause 1
  drag by(0, 20)
  
  # Pause a bit
  pause 2  

  move to_element('#save_activity_type_button')
  pause 1
  click
end

# Wait for the page to load
pause 5