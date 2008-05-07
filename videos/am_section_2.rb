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

# START VIDEO 1

# Click on a.
move to_element('#two a')
pause 3
click

pause 4

# Scroll down and click on first strategic objective, then show the answers,
move to_element('#strategy_responses_1')

# Click yes then save.
drag by(0, 15)
pause 3

move to_element('#section_save_button')
click

pause 4

# Click on b. Click on service users. Yes then save.
move to_element('#two a', :index => 1)
click

pause 4

move to_element('#activity_purpose_overall_5')
drag by(0, 15)

pause 3

move to_element('#section_save_button')
click

# Show a & b incomplete ie red cross then complete ie green tick.
move to_element('.letter_completed', :index => 0)
highlight do
  pause 2
  move to_element('.letter_completed', :index => 1)
  pause 2
end

# Click on c.
move to_element('#two a', :index => 2)
pause 3
click

pause 4

# Click on men and women question, click on none at all,
move to_element('#activity_purpose_gender_3')
drag by(0, 15)

pause 3

# then click on negative men and women question click some impact, then save.
move to_element('#activity_purpose_gender_4')
drag by(0, 15)

pause 3

# END VIDEO 1

# START VIDEO 2

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
end

# END VIDEO 2