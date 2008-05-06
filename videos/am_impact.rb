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

# Click on disability edit pencil.

# Click on first question.

# Click on down arrow. Click good.

# Click on next question, click yes.

# Complete evidence section
# ‘strategy designed specifically to engage with people with disabilities’

# Click not applicable for next question.

# Click no for the issues question.

# Click save.

# Show the green tick on the questions page.