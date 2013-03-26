# encoding: utf-8

$:.push(File.dirname($0))
require 'library'
require 'settings'

# adds a new category to the daily log, takes a category number, and uses the current time
# using append means that the file will be created if it doesn't already exist
def log(cat, silent = false)
  oldcat, _ = status
  fail format_status("Already doing ") if oldcat == cat && silent==false         # to avoid duplicate entries

  t = Time.now.to_s # convert to string, strip out timezone
  File.open(Filename,'a') {|f| f << "#{t}\t#{cat}\n" }

  # trigger internet connection depending on category
  if cat.index('offline') && !oldcat.index('offline')
    internet(false)
  elsif oldcat.index('offline')
    internet(true)
  end
end

def get_custom_cats
  path = "#{Path}/usercategories.txt"
  return nil unless File.exists?(path)
  return try { File.read(path).split("\n") }
end

def write_custom_cats(cats)
  path = "#{Path}/usercategories.txt"
  File.open(path, 'w') { |f| f << cats.join("\n") }
end

# display a list of categories, and allow entering new ones (for now, not saved anywhere)
def select_list
  require 'pashua'
  include Pashua

  config = "
  *.title = personal time tracker
  cb.type = combobox
  cb.completion = 2
  cb.width = 400
  cb.default = surfing
  cb.tooltip = Choose from the list
  db.type = cancelbutton
  db.label = Cancel
  db.tooltip = Closes this window without taking action" + "\n"

  # insert list of all choices
  cust = get_custom_cats || []
  cat = (cust ? cust + Categories : Categories)
  cat.each { |c| config << "cb.option = #{c}\n" }
  pagetmp = pashua_run config
  exit if pagetmp['cancel'] == 1 || pagetmp['cb'] == nil

  choice = pagetmp['cb'].strip
  log(choice)

  unless cat.index(choice)
    cust << choice
    write_custom_cats(cust)
  end
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

  # timeline
  midnight = timeify(Time.now.to_s[0..10] + Time.now.to_s[-5..-1]) # find midnight
  log = File.read(Filename) + "#{Time.now.to_s}\tbreak"
  File.open("#{Path}/tmp/stats-timeline.csv", 'w') do |f|
    f << "Activities, Start, End\n"
    last = 0
    lastc = ''
    logary = []
    log.each_line do |l|
      next unless l.index("\t")
      t, c = l.split("\t")
      tt = timeify(t) - midnight
      f << "#{lastc.strip}, #{last}, #{tt}\n" unless last == 0 || lastc.strip == 'break'
      last = tt
      lastc = c
    end
  end

  # cumulative stats category/time
  cumul, tot_time = get_daily_totals(log) # list each category, and it's time use
  File.open("#{Path}/tmp/stats.csv", 'w') do |f|
    f << "Activity, Minutes\n"
    cumul.each do
      |x,y| f << "#{x}, #{y/60.0}\n" if y>1
    end
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

select_list if ARGV[0] == 'list'


ping if ARGV[0] == 'ping'

daily_total if ARGV[0] == '-'

if "0123456789".index(ARGV[0])
  cat = Categories[ARGV[0].to_i]

  stat = format_status("Last was ")
  log(cat)

  growl("#{cat}\r\r#{stat}")
end

growl "Remember to choose activity" if ARGV[0] == 'remind'
log("break", silent=true) if ARGV[0] == '0silent' # on shutdown, don't display growl
