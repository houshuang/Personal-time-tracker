# encoding: utf-8

$:.push(File.dirname($0))
require 'library'
require 'settings'

# adds a new category to the daily log, takes a category number, and uses the current time
# using append means that the file will be created if it doesn't already exist
def log(cat)
  oldcat, _ = status
  fail format_status("Already doing ") if oldcat == cat         # to avoid duplicate entries

  t = Time.now.to_s # convert to string, strip out timezone
  File.open(Filename,'a') {|f| f << "#{t}\t#{cat}\n" }
end

# returns a line with current activity and time, with a prefix, or empty if no current activity
def format_status(prefix = '')
  cat, t_elapsed = status
  return "" if !cat or cat == "break"
  return "#{prefix}#{cat}, for #{minutes_format(t_elapsed)}"
end

def hotkeys
  text = "Hotkeys:\r\r"
  Categories.each_with_index do |x,y|
    text << "#{y}: #{x}\r"
  end

  return text
end

# print hotkeys, as a reminder
def print_hotkeys
  text = format_status("Current is ") + "\r\r" + hotkeys
  growl text
end

def daily_total
  cat, t_elapsed = status
  fail "No time tracked so far today" unless cat

  cumul, tot_time = get_daily_totals # list each category, and it's time use

  File.open("#{Path}/tmp/stats.csv", 'w') do |f|
    f << "Activity, Minutes\n"
    cumul.each {|x,y| f << "#{x}, #{y/60.0}\n" if y>1}
  end

  # run the Rscript that generates the PDF
  `cd ~;/usr/bin/Rscript #{Path}/daygraph.R`

  require 'pashua'
  include Pashua
  config = "
    *.title = Time use
    img.type = image
    img.label = Total: #{minutes_format(tot_time)}. #{format_status('Right now, ')}
    img.path = #{Path}/tmp/plot.pdf
    img.maxwidth = 900
    img.border = 1"
  pagetmp = pashua_run config

  # `rm #{Path}/tmp/plot.pdf; rm #{Path}/tmp/stats.csv`
end

# called from crontab like this
# */5 * * * * ruby PATH/Personal-time-tracker/ping.rb
# idea is to remind you of the category (to avoid forgetting to switch), and keep you on track
def ping
  fmt = format_status
  growl(format_status) if fmt.size > 0
end

# =========================================================================

print_hotkeys if ARGV[0] == '='

ping if ARGV[0] == 'ping'

daily_total if ARGV[0] == '-'

if "0123456789".index(ARGV[0])
  cat = Categories[ARGV[0].to_i]

  stat = format_status("Last was ")
  log(cat)

  growl("#{cat}\r\r#{stat}")
end