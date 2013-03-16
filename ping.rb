# encoding: utf-8

# uses growl to show current activity and time elapsed, today's totals for all categories, and
# cheat sheet for keyboard codes

$:.push(File.dirname($0))
require 'library'
require 'settings'
require 'csv'

cat, t_elapsed = status
unless cat == 'break'
growl "#{cat} (#{minutes_format(t_elapsed)})"