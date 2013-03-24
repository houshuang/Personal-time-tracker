# encoding: utf-8

$:.push(File.dirname($0))
require 'library'
require 'settings'
require 'yaml'
require 'Pashua'
include Pashua

# tags arbitrary facts using key-value

categories = try { YAML::load(File.read('categories.txt')) }
categories = [""] unless categories

config = "
*.title = Log something

*.title = loggr
cb.type = combobox
cb.completion = 2

cb.default = start
cb.width = 220
cb.tooltip = Choose from the list or enter another name
tb.type = textbox
timelab.type = text
timelab.default = Time stamp
time.type = textfield
time.default = #{Time.now}
cancel.type = cancelbutton
cancel.label = Cancel
cancel.tooltip = Closes this window without taking action" + "\n"

categories.each {|cat| config << "cb.option = #{cat}\n" }

# insert list of all wiki pages from filesystem into Pashua config
pagetmp = pashua_run config
exit if pagetmp['cancel'] == 1

cat = try { pagetmp['cb'].strip }
unless categories.index(cat)
  categories << cat
  categories - [""] # remove empty field if we have categories
  File.open('categories.txt', 'w') {|f| f << YAML::dump(categories)}
end