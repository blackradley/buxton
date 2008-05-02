plugin "safari"
plugin "mousepose"
plugin "ishowu"

launch "Mousepose"

launch "Safari", at(20, 40, 1024, 768)
url "http://gadgets.inventivelabs.com.au"

ishowu_set_region at(4, 24, 1056, 800)
ishowu_start_recording

while_saying "
  Tabulate is a bookmarklet developed by Inventive Labs. 
  You use it to open links on a web page. 
  It's meant for iPhones, but we'll demonstrate it in Safari 3.
" do
  move to(240, 72)
  tripleclick
  type "http://gadgets.inventivelabs.com.au/tabulate"
  hit Enter
  pause 2
end

while_saying "To install it, drag it to your bookmarks bar." do
  move to_element("a.button")
  drag to(88, 106)
  pause 0.5
  hit Enter
end

while_saying "Let's try it out on delicious." do
  url "http://del.icio.us"
  pause 2
end

while_saying "Simply invoke the bookmark..." do
  highlight
  pause 1
  click
  pause 0.5
end

while_saying "
  The status box appears, indicating that Tabulate is active.
" do
  move to_element("body", :area => ["top", "left"]), offset(30, 30)
end

dim

while_saying "If you see a link that interests you, tap it." do
  move to_element("h4 a", :area => ["top", "left"])
  click
end

pause 1

highlight do
  while_saying "
    You would tap the blue circle to open the link in this tab.
  " do
    move to_element("#_tabulate_box img", :index => 1)
  end

  while_saying "Tap the green circle to open in a new tab." do
    move to_element("#_tabulate_box img", :index => 2)
  end

  while_saying "
    Most people use Tabulate to flag links for opening later. 
    This is what the orange circle does.
  " do
    pause 1.5
    move to_element("#_tabulate_box img", :index => 3)
    pause 1
    click
  end
end

while_saying "Let's flag the next two links as well." do
  i = 1
  while (i <= 2)
    move to_element("h4", :area => ["top", "left"], :index => i)
    click
    move to_element("#_tabulate_box img", :index => 3)
    click
    i += 1
  end
end


while_saying "
  On the iPhone, we would open these three links simultaneously 
  by tapping on the status box.
" do
  highlight do
    move to_element("body", :area => ["top","left"]), offset(30,30)
  end
end

pause 1

say "That's all. Thanks for watching!"