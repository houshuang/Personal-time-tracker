# uses growl to show current activity and time elapsed, today's totals for all categories, and 
# cheat sheet for keyboard codes

require "#{File.dirname($0)}/library" # script might be launched from another directory

cumul = Hash.new # will hold the totals for today for each category
ensure_file(Filename) # just to avoid crashing

# get last activity logged
cat, t_elapsed = status
cumul.add(cat, t_elapsed) # add the current status to the cumulative totals, because they won't emerge from below
text = "Current is #{cat}, spent #{minutes_format(t_elapsed)}\r\rSo far today:\r"

# go through today's file, and add up all the totals
f = File.open(Filename,'r')
oldcategory = 0
oldtime = 0
f.each do |line|
  time, category = line.split("\t")
  category.strip!
  next if oldcategory == category # ignore if someone pressed the same category twice - just count it as one long event
  
  unless oldcategory == 0 # if they were resting, and then started an event. we don't count resting.
    cumul.add(oldcategory,(time.to_i-oldtime.to_i))
  end
  
  # store it, and move to the next line
  oldcategory = category 
  oldtime = time
end

# list each category, and it's time use
cumul.each do |x,y| 
  text << "#{x}: #{minutes_format(y)}\r"
end

# print hotkeys, as a reminder
text << "\rHotkeys:\r"
Categories.each_with_index do |x,y|
  text << "#{y}: #{x}\r"
end

growl("Use of time today:", text)