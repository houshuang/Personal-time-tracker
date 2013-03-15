# encoding: utf-8

# researchr scripts relevant to BibDesk (the right one is executed from the bottom of the file)

$:.push(File.dirname($0))
require 'utility-functions'
require 'library'

f = File.open('tracker.dat','r')

oldcategory = 0
oldtime = 0
f.each do |line|
  time, category = line.split("\t")
  category = category.to_i
  next if oldcategory == category

  if oldcategory == 0

    oldcategory = category
    oldtime = time
    next
  end
  printf ("#{Time.at(oldtime.to_i).to_s.split(" ")[0..3].join(" ")}: Category #{oldcategory}: %d.1\n", ((time.to_i-oldtime.to_i)/60.0))
  oldcategory = category
  oldtime = time
end
