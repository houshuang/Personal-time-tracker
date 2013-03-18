# encoding: utf-8

# uses growl to show current activity and time elapsed, today's totals for all categories, and
# cheat sheet for keyboard codes

$:.push(File.dirname($0))
require 'library'
require 'settings'
require 'csv'

cat, t_elapsed = status

fail "No time tracked so far today" unless cat
#text = "Current is #{cat}, spent #{minutes_format(t_elapsed)}.\r\rSo far today:\r"
text=''
# list each category, and it's time use
cumul, tot_time = get_daily_totals
puts tot_time

# print hotkeys, as a reminder
text << "\rHotkeys:[return][return]"
Categories.each_with_index do |x,y|
  text << "#{y}: #{x}[return]"
end

#growl("Use of time today:", text)
x = cumul.map{|x,y| x}
y = cumul.map{|x,y| y}
File.open("#{Path}/tmp/stats.csv", 'w') do |f|
  f << "Activities, Minutes\n"
  cumul.each {|x,y| f << "#{x}, #{y/60.0}\n" if y>1}
end

`cd ~;/usr/bin/Rscript #{Path}/daygraph.R`

require 'pashua'
include Pashua



config = "
*.title = Time use
img.type = image
img.label = Total: #{minutes_format(tot_time)}. Right now: #{cat}, for #{minutes_format(t_elapsed)}
img.path = #{Path}/tmp/plot.pdf
img.maxwidth = 900
img.border = 1
"

pagetmp = pashua_run config
`rm #{Path}/tmp/plot.pdf; rm #{Path}/tmp/stats.csv`
