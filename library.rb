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

Path = File.dirname($0)
t = Time.now
Filedate = sprintf("%04d.%02d.%02d", t.year, t.month, t.day)
Filename = Path + "/" + Filedate

Categories = [
  "taking a break", #0 - this is the one to use when stepping away from the computer
  "Thesis", #1
  "GAship", #2
  "IRR", #3
  "P2PU", #4
  "AVU", #5
  "goofing", #6
  "project 1", #7
  "project 2"] #8 - #9 is reserved for the status message
  
def ensure_file(filename)
  unless File.exist?(filename)
    File.open(filename, "w") {|f| f << "#{Time.now.to_i}\t#{Categories[0]}\n"}
  end
end

def status # return the current status, ie. category and time elapsed
  last = File.read(Filename).split("\n").pop # last line
  time, cat = last.split("\t")

  t_elapsed = Time.new.to_i - time.to_i
  return cat.strip, t_elapsed
end

def growl(title, text, test=false)
  unless test
    `growl "#{title}" -m "#{text}"` 
  else
    puts "Title: #{title.gsub("\r","\n")}\n#{text.gsub("\r","\n")}" # just for debugging, by default off
  end
end

def minutes_format(min)
 sprintf("%d.1 min", (min)/60.0)
end