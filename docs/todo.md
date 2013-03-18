# next steps
- write a blog entry about things to track etc.
- discuss with Bodong about ways of storing things in R etc

# bugs:
- when you first choose an activity, when there is no file existing, it creates a file and adds break, no matter what you selected

# feature requests:
- rewrite dates to use actual dates, easier to parse for R? also easier to change manually. remove time zone.

# to figure out:
- how to deal with categories, for example I want to track how much time I'll spend preparing the presentation for an upcoming conference, but I also want to track all the time spent preparing for conferences...
  - simply add categories in the settings.rb, for example "Prepare for btpdf2", ['presentation', 'conference', 'OA']
  - how to store this information, and visualize it meaningfully (same problem as with blog tags, how do you store multiple categories in R?)
  - do categories have to be exclusive? otherwise summing up will not make sense (Similar problem with economy trackers)
- how to store random events (key/value) and make it easy to analyze/relate to other events etc?

# ideas for things to track:

## things that are easy:
- Fitocracy API - number of points earned (number of km ridden/walked?)
- number of PDF documents read, number of pages, length of notes written, other wiki pages
- history API for Chrome, number of web sites visited? (unique URLs / domains
  - number of links opened from HN?
- GMail interface - number of emails received/replied, number of unique addresses etc?
  - something already exists? or handwrite using mail library?
- Twitter/GPlus, not very interesting
- blog posts written

## manually:
- some kind of key value store, that is unobtrusive and easy to call up (but how to store the data?)
  - books read
  - food eaten? (how, rating?)
  - bed time (not going to be consistent, precise)
  - weight
  - randomly pop up and ask questions (tired, productive, distracted, happy, etc?)

## things that are impossible but should be easy:
- Kindle, pages read, books read
- activity, sleep etc from Fitbit

# create reports
Using R+knitr, and a templating language, insert all the data, run knitr through RScript on the command line, generate nice reports (daily, weekly, monthly?)