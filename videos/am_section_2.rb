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

# Starts with section 2 appearing.

# Click on a.

# Scroll down and click on first strategic objective, then show the answers,

# Click yes then save.

# Click on b.  Click on service users. Yes then save.

# Show a & b incomplete ie red cross then complete ie green tick.

# Click on c.

# Click on men and women question, click on none at all,

# then click on negative men and women question click some impact, then save.

# Show all green ticks against a, b, c and section 3.