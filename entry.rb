# adds a new entry to the daily ledger, and uses growl to give feedback, and show how long was
# spent on the previous activity

require "#{File.dirname($0)}/library"

t = Time.now

ensure_file(Filename) # make sure it exists

id = ARGV[0] # key pressed
cat = Categories[id.to_i]

oldcat, t_elapsed = status
text = "Last was #{oldcat}, spent #{minutes_format(t_elapsed)}."

File.open(Filename,'a') {|f| f << "#{Time.now.to_i}\t#{cat}\n" }
growl(cat, text)
