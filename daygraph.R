library(ggplot2)
setwd('~/src/Personal-time-tracker/tmp')

df <- read.csv('stats.csv', header=T)
a <- ggplot(df, aes(x=Activity, y=Minutes, fill=Activity)) + geom_bar(stat="identity") + geom_text(aes(label=floor(df$Minutes)), size = 3, hjust = 0.5, vjust = 3, position =     "stack")

ggsave('plot.pdf', a, width = 12, height = 6)