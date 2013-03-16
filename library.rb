# encoding: utf-8
$:.push(File.dirname($0))
require 'settings'
# useful functions used by the tracker

class Hash
  def add(var,val)
    if self[var].nil?
      self[var] = val
    else
      self[var] = self[var] + val
    end
  end
end

t = Time.now
Filedate = sprintf("%04d.%02d.%02d", t.year, t.month, t.day)
Filename = Path + "/" + Filedate

def ensure_file(filename)
  unless File.exist?(filename)
    File.open(filename, "w") {|f| f << "#{Time.now.to_i}\t#{Categories[0]}\n"}
  end
end

def status # return the current status, ie. category and time elapsed
  last = try { File.read(Filename).split("\n").pop }# last line
  return nil unless last
  time, cat = last.split("\t")

  t_elapsed = Time.new.to_i - time.to_i
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
  min = sec / 60.0
  out = ''
  if min > 60
    hr = min / 60
    min = min - (hr.to_i * 60)
    out << "#{hr.to_i} hrs "
  end
  out << "#{min.to_i} min" if min > 0
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

# go through today's file, and add up all the totals
def get_daily_totals
  # get last activity logged
  cumul = Hash.new # will hold the totals for today for each category

  cat, t_elapsed = status
  cumul.add(cat, t_elapsed) # add the current status to the cumulative totals, because they won't emerge from below

  #ensure_file(Filename) # just to avoid crashing

  f = File.open(Filename,'r')
  oldcategory = 0
  oldtime = 0
  tot_time = 0 # spent by all projects today (ie. time in front of the computer)
  f.each do |line|
    time, category = line.split("\t")
    category.strip!

    unless oldcategory == "break" || oldcategory == 0 # if they were resting, and then started an event. we don't count resting.
      t_spent = time.to_i-oldtime.to_i
      cumul.add(oldcategory, t_spent)
      tot_time = tot_time + t_spent
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