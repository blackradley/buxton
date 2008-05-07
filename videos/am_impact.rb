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

launch 'Safari', at(100, 50, 1024, 768)
url 'http://localhost:3000/cc533d9de98744a379c47b8df037242c6738ed4f'
pause 4
url 'http://localhost:3000/activities/questions'
pause 8

# Click on disability edit pencil.
move to_element('#disability_impact_completed')
highlight do
  pause 2
  move to_element('#disability_impact_pencil')
  pause 2
  click
end

pause 6

# Click on first question. Click on down arrow. Click good.
move to_element('#activity_impact_disability_1'), offset(0, -30)
click
pause 2
move to_element('#activity_impact_disability_1')
drag by(0, 45)

# Click on next question, click yes.
move to_element('#activity_impact_disability_2'), offset(0, -30)
click
pause 2
move to_element('#activity_impact_disability_2')
drag by(0, 15)

# Complete evidence section
# ‘strategy designed specifically to engage with people with disabilities’
move to_element('#activity_impact_disability_3'), offset(0, -30)
click
pause 2
move to_element('#activity_impact_disability_3')
click
type 'strategy designed specifically to engage with people with disabilities'

# # Click No for next question.
move to_element('#activity_impact_disability_8')
move to_element('#activity_impact_disability_6'), offset(0, -30)
click
pause 2
move to_element('#activity_impact_disability_6')
drag by(0, 30)

# Click not applicable for next question.
move to_element('#activity_impact_disability_8'), offset(0, -30)
click
pause 2
move to_element('#activity_impact_disability_8')
drag by(0, 60)

# Click no for the issues question.
move to_element('#activity_impact_disability_9'), offset(0, -30)
click
pause 2
move to_element('#activity_impact_disability_9')
drag by(0, 30)

# Click save.
move to_element('#section_save_button')
click

pause 10

# Show the green tick on the questions page.
move to_element('#disability_impact_completed')
highlight do
  pause 2
end