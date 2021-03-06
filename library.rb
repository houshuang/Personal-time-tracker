# encoding: utf-8

$:.push(File.dirname($0))
require 'settings'
require 'date'

# useful functions used by the tracker

t = Time.now
Filedate = sprintf("%04d.%02d.%02d", t.year, t.month, t.day)
Filename = Path + "/log/" + Filedate

class Hash
  def add(var,val)
    if self[var].nil?
      self[var] = val
    else
      self[var] = self[var] + val
    end
  end
end

# enable or disable internet by temporarily replacing HOSTS file with one that blocks all connections
def internet(status) # true = on, false = off
  if status # enable
    `ipfw -q flush`
  else
    `ipfw add allow all from any to 127.0.0.1;ipfw add deny all from any to any`
  end
end

# returns the current status, ie. category and time elapsed, or nil if no activity in progress
def status
  last = try { File.read(Filename).split("\n").pop }# last line
  return nil unless last
  time, cat = last.split(",")
  begin_activity = DateTime.parse(time).to_time.to_i
  curtime = Time.now.to_i
  t_elapsed = curtime - begin_activity
  return cat.strip, t_elapsed
end

# shows notification on screen. one or two arguments, if one, just shows a message, if two, the first is the title
# notice the path to growl
def growl(title, text='', url='')
  require 'Appscript'
  if text == ''
    text = title
    title = ''
  end

  growlapp=Appscript.app('Growl')
  growlapp.register({:as_application=>'Researchr', :all_notifications=>['Note'], :default_notifications=>['Note']})
  growlapp.notify({:with_name=>'Note',:title=>title,:description=>text,:application_name=>'Researchr', :callback_URL=>url})
end

def minutes_format(sec)
  sec = 60 if sec == nil || sec < 60
  min = sec / 60.0
  out = ''
  if min > 60
    hr = min / 60
    min = min - (hr.to_i * 60)
    out << "#{hr.to_i} hrs "
  end
  out << "#{min.to_i} min" if min.to_i > 0
  out
end

# returns either the value of the block, or nil, allowing things to fail gracefully. easily
# combinable with fail unless
def try(default = nil, &block)
  if defined?(DEBUG)
    yield block
  else
    begin
      yield block
    rescue
      return default
    end
  end
end

# go through today's file, and add up all the totals, returns array of activities and seconds, plus
# total time spent (seconds)
def get_daily_totals(log)
  cumul = Hash.new # will hold the totals for today for each category
  return [] if log == nil
  # get last activity logged
  cumul.add(*status) # add the current status to the cumulative totals, because they won't emerge from below

  oldcategory = 0
  oldtime = 0
  tot_time = 0 # spent by all projects today (ie. time in front of the computer)
  log.each_line do |line|
    next unless line.index(",")
    timestr, category = line.split(",")
    time = timeify(timestr)
    category.strip!

    unless oldcategory == "break" || oldcategory == 0 # if they were resting, and then started an event. we don't count resting.
      t_spent = time.to_i - oldtime.to_i
      cumul.add(oldcategory, t_spent)
      tot_time += t_spent
    end

    # store it, and move to the next line
    oldcategory = category
    oldtime = time
  end

  return cumul, tot_time
end

# displays and error message and exits (could optionally log, not implemented right now)
# mainly to enable one-liners instead of if...end
def fail(message)
  growl "Failure!", message
  exit
end

def timeify(timestr)
  DateTime.parse(timestr).to_time.to_i
end

def gen_weekly_stats
  days = Dir.glob(Path + "/log/*.*.*", File::FNM_CASEFOLD).sort {|x,y| y <=> x}[0..6]

  activity_total = Hash.new
  traffic = Array.new
  weektot = 0
  traffic = File.open(Path + "/tmp/traffic.csv", 'w')
  traffic << "Sequence,Day,Performance\n"
  weeklytot = File.open(Path + "/tmp/weeklytot.csv", 'w')
  weeklytot << "Activity,Seconds,Time\n"

  days.each_with_index do |day, i|
    log = File.read(day)
    tot = get_daily_totals(log)
    tot[0].each_pair {|x, y|
      activity_total.add(x, y) unless x == "surfing" }
    weektot += tot[1]

    dayname = day[Path.size + 5..-1]
    phdtot = 0
    tot[0].each_pair {|x, y| phdtot += y if x.downcase.index('phd') }
    traffic_color = case
    when phdtot < 2*60*60
      day == Filename ? 'grey' : 'red'  # only grey if current day, still possible
    when phdtot < 4*60*60
      'yellow'
    when phdtot > 4*60*60
      'green'
    end

    traffic << "#{i + 1},#{dayname},#{traffic_color}\n"
  end
  activity_total.each_pair {|x, y| weeklytot << "#{x},#{y},#{minutes_format(y)}\n"}
  weeklytot << "Total,#{weektot},#{minutes_format(weektot)}\n"
  weeklytot << "Average,#{weektot/7},#{minutes_format(weektot/7)}\n"
  traffic.close
  weeklytot.close
  return weektot
end
