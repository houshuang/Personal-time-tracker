# next steps
- discuss with Bodong about ways of storing things in R etc

# ideas
- track when computer is sleeping, use special code for this, ie. can track when at computer or not. "away". when opening computer automatically turn on "surfing".
- does it make sense to track inactivity? if I'm reading a PDF document, assume that I will still move more than every few minutes... watching movie etc?
- record last activity before break, and enable toggling back to it (like 3+J in Researchr)

What if you could enter any combination of tags, more specific and less specific, through a pop-up interface
for example: meeting,laurie. The 10 quick keys would just be arbitrary sets of tags that could be changed at any time... Problem: how to store (of course, or more, how to analyze), and lack of autocompletion?

Probably end up using an sqlite3 database to store, figure out which library/ORM that is easy to use/lightweight. Sequel? Define day as 05:01AM to 05:00AM, write day field as well as Time stamp (Time.now.to_date - 5.hours?). Draw several days' timelines under each other, with vertical lines for 8AM, 5PM, 11PM. Create a activity chooser with Pashua and see if it gets used more than the shortcuts (also show shortcuts). Probably just projects + one level of category, exclusive. Dashboard with lights, for example green for >4 hr of PhD work per day, show long view (one month etc).

# to figure out:
- how to deal with categories, for example I want to track how much time I'll spend preparing the presentation for an upcoming conference, but I also want to track all the time spent preparing for conferences...
  - simply add categories in the settings.rb, for example "Prepare for btpdf2", ['presentation', 'conference', 'OA']
  - how to store this information, and visualize it meaningfully (same problem as with blog tags, how do you store multiple categories in R?)
  - do categories have to be exclusive? otherwise summing up will not make sense (Similar problem with economy trackers)
- how to store random events (key/value) and make it easy to analyze/relate to other events etc?

# ideas for things to track:

## things that are possible:
- Fitocracy API - number of points earned (number of km ridden/walked?)
- number of PDF documents read, number of pages, length of notes written, other wiki pages
- history API for Chrome, number of web sites visited? (unique URLs / domains
  - number of links opened from HN?
- GMail interface - number of emails received/replied, number of unique addresses etc?
  - something already exists? or handwrite using mail library?
- Twitter/GPlus, not very interesting
- blog posts written
- files changed, useful?
- Kindle, pages read, books read - need SSH

## manually:
- some kind of key value store, that is unobtrusive and easy to call up (but how to store the data?)
  - books read
  - food eaten? (how, rating?)
  - bed time (not going to be consistent, precise)
  - weight
  - randomly pop up and ask questions (tired, productive, distracted, happy, etc?)

## things that are impossible but should be easy:
- activity, sleep etc from Fitbit

# create reports
Using R+knitr, and a templating language, insert all the data, run knitr through RScript on the command line, generate nice reports (daily, weekly, monthly?)