# encoding: utf-8

$:.push(File.dirname($0))
require 'library'
require 'settings'
require 'rinruby'

# adds a new entry to the daily ledger, and uses growl to give feedback, and show how long was
# spent on the previous activity

t = Time.now
oldcat, t_elapsed = status

ensure_file(Filename) # make sure it exists

id = ARGV[0] # key pressed

if id == "="
  # print hotkeys, as a reminder
  text ="Currently #{oldcat}, #{minutes_format(t_elapsed)} elapsed.\r\r"
  text << "\rHotkeys:\r\r"
  Categories.each_with_index do |x,y|
    text << "#{y}: #{x}\r"
  end
  growl text
  exit
end


cat = Categories[id.to_i]

text = "Last was #{oldcat}, spent #{minutes_format(t_elapsed)}."

File.open(Filename,'a') {|f| f << "#{Time.now.to_i}\t#{cat}\n" }
growl(cat, text)

R.eval <<EOF


EOF