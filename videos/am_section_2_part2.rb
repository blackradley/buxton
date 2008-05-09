#!/usr/bin/env castanaut

LIVE = (ARGV[0] == '-L') || false

plugin 'safari'
plugin "mousepose"
launch "Mousepose"

if LIVE
  plugin "ishowu"
  ishowu_set_region at(84, 34, 1056, 800)
end

# Starts with section 2 appearing.
launch 'Safari', at(100, 50, 1024, 768)
url 'http://192.168.0.2:3000/cc533d9de98744a379c47b8df037242c6738ed4f'
pause 4
url 'http://192.168.0.2:3000/activities/questions'
pause 8

if LIVE
  ishowu_start_recording
  pause 4
end

# Show all green ticks against a, b, c and section 3.
move to_element('.letter_completed', :index => 0)
highlight do
  pause 2
  move to_element('.letter_completed', :index => 1)
  pause 2
  move to_element('.letter_completed', :index => 2)
  pause 2
  move to_element('#disability_impact_completed')
  pause 2
  move to_element('#disability_consultation_completed')
  pause 2
  move to_element('#disability_additional_work_completed')
  pause 2
  move to_element('#disability_action_planning_completed')
  pause 2  
  move to_element('#submit_answers a')
  pause 2
end

pause 4