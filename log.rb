# encoding: utf-8

# tags arbitrary facts using key-value

$:.push(File.dirname($0))
require 'library'
require 'settings'
require 'Pashua'
include Pashua

categories = try { YAML::load(File.read('categories.txt')) }
categories = [""] unless categories

config = "
*.title = Log something

  *.title = researchr
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
  db.type = cancelbutton
  db.label = Cancel
  db.tooltip = Closes this window without taking action" + "\n"

categories.each {|cat| config << "cb.option = #{cat}" }

  # insert list of all wiki pages from filesystem into Pashua config
  pagetmp = pashua_run config

