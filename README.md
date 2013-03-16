# Read about this project on my blog:
- 2010: [Personal time tracker with Ruby and Growl](http://reganmian.net/blog/2010/04/29/personal-time-tracker-with-ruby-and-growl)
- 2013: [Unobtrusive time tracker - visualizing time spent with Ruby and R](http://reganmian.net/blog/2013/03/16/unobtrusive-time-tracker-visualizing-time-spent-with-ruby-and-r/)

Inspired by a [New York Times article](http://www.nytimes.com/2010/05/02/magazine/02self-measurement-t.html) on the [quantified self](http://quantifiedself.com/).

This was developed by [Stian Håklev](http://reganmian.net/blog), shaklev@gmail.com, using a few snippets from other sources. I release it under Public Domain. But feel free to share
any modifications. I totally wrote this to scratch my own itch, but if you
find this, or a version of this, useful, letting me know would totally make my
day.

Note that the code is pretty messy right now, I'll probably clean it up as I go
along, but anyway it's a very small project, so it shouldn't be hard to figure
it out and play around with it.

# Installation

## Configuration and running
- first, edit the Categories list in settings.dist.rb and save this file as settings.rb to reflect the categories you care about. Personally I have chosen 0 to be "stepping away from the computer", this category isn't counted. You can change it as many times as you want - it writes the entire text, not the number, to the data file, so your data won't be confused if you track "editing wikipedia" on 3 for two days, and then change 3 to tracking "contributing to KDE"
- for every time you start a new activity (and by extension, end an old one - there isn't a way of "just ending" an activity, you always start a new one - even if the new one is "resting" (0)), you run entry.rb, with the number as a command line argument. For example, /usr/bin/ruby entry.rb 4, which will change your status to category 4, write a timestamp in today's file, and pop up a short message about that.
- to display the current status, you run status.rb

## R
- you need R with the ggplot2 package installed for the graphs.

## Growl
- this program uses growl, which has to be installed (http://growl.info/).

## Global hotkeys
- the whole point of this program is to be extremely unobtrusive and "fit in" with your workflow, so of course, you don't want to have to switch to terminal and type "entry 4" every time you start doing something else. I have tied entry 0-8 to Cmd+Opt 0-8, and status to Cmd+Opt 9 (note that theoretically, you can tie Cmd+Alt S to status, and you can assign all the letters in the alphabet to differently numbered categories - I wouldn't recommend it though, the point is that there shouldn't be much cognitive load when switching tasks)
- I use [Keyboard Maestro](http://www.keyboardmaestro.com/main/) to launch the scripts, but you can use whatever tool you're comfortable with. If you use Keyboard Maestro, you can import the macros from macrofile.kmmacros, but first you have to open it in a text editor and search and replace my directory and ruby invocation (don't know of an automatic way of doing this)

# TODO
- deal with midnight-switch
- more fancy graphs, time series, week/month view, etc
- replace text files with sqlite?
- create a seamless installer (I am not going to do this, but others are
  welcome to!)