library(ggplot2)
library(gridExtra)
setwd('~/src/Personal-time-tracker/tmp')
pdf(file = 'plot.pdf', width = 12, height = 6)

df <- read.csv('stats.csv', header=T)
aplot <- ggplot(df, aes(x=Activity, y=Minutes, fill=Activity)) + geom_bar(stat="identity") + geom_text(aes(label=floor(df$Minutes)), size = 3, hjust = 0.5, vjust = 3, position =     "stack")


df2 <- read.csv('stats-timeline.csv', header=T)
a <- 0:23
bplot <-ggplot(df2, aes(colour=Activities)) + geom_segment(aes(x=Start, xend=End, y=0, yend=0), size=10)  + scale_x_continuous(breaks=(a-1)*60*60, labels=a) + xlab("Time") + ylab("") + scale_y_continuous(breaks=NULL, limits=c(-.1,.1) )
grid.newpage()
pushViewport(viewport(layout=grid.layout(2,1)))
print(aplot, vp=viewport(layout.pos.row=1, layout.pos.col=1))
print(bplot, vp=viewport(layout.pos.row=2, layout.pos.col=1))

dev.off()
                                                                                                                                                                                                    