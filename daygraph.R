library(ggplot2)
library(gridExtra)
setwd('/Users/Stian/src/Personal-time-tracker/tmp')
pdf(file = 'plot.pdf', width = 12, height = 8)

# daily activity barchart
df <- read.csv('stats.csv', header=T)
aplot <- ggplot(df, aes(x=Activity, y=Minutes, fill=Activity)) +
  geom_bar(stat="identity") +
  geom_text(aes(label=df$Tim), size = 3, hjust = 0.5, vjust = 1.5, position = "stack") + xlab("") +
  ylab("") +
  ggtitle("Activities today")
  

# weekly total barchart
weeklytot <- read.csv('weeklytot.csv', header=T, as.is=T)
total = weeklytot[weeklytot$Activity == 'Total',]
average = weeklytot[weeklytot$Activity == 'Average',]
ws = weeklytot[weeklytot$Seconds>60*60,]
ws = ws[ws$Activity != 'Total',]
weeklytot_signif = ws[ws$Activity != 'Average',]
cplot <-   
  ggplot(weeklytot_signif, aes(x=Activity, y=Seconds, fill=Activity)) +
  geom_bar(stat="identity") +
  geom_text(aes(label=weeklytot_signif$Time),
            size = 3, hjust = 0.5, vjust = 1.5, position = "stack") +
  ggtitle(paste("Activities this week (total: ", total$Time, 
    ", average per day: ", average$Time, ")")) + 
  xlab("") + ylab("") +
  scale_y_continuous(breaks=NULL) 

# daily timeline
df2 <- read.csv('stats-timeline.csv', header=T)
a <- 0:23

bplot <-ggplot(df2, aes(colour=Activities)) + geom_segment(aes(x=Start, xend=End, y=0, yend=0), size=10) +
  scale_x_continuous(breaks=(a)*60*60, labels=a) +
  xlab("") +
  ylab("") +
  scale_y_continuous(breaks=NULL, limits=c(-.1,.1) ) +
  theme(legend.position="none") + # already have legend above
  geom_vline(xintercept = 8*60*60, color='red') +
  geom_vline(xintercept = 17*60*60, color='red') +
  geom_vline(xintercept = 23*60*60, color='red') + 
  ggtitle("Timeline today")

  
traffic = read.csv('traffic.csv', header=T, as.is=T)
trafficplot = ggplot(traffic, aes(x=Day)) + 
geom_bar(aes(fill=Performance)) + 
scale_fill_identity() + 
ylab("") + xlab("") + 
scale_y_continuous(breaks=NULL) +
theme(legend.position="none") + 
ggtitle("PhD performance last 7 days") + 
coord_fixed(ratio = 0.1)

grid.newpage()
pushViewport(viewport(layout=grid.layout(4,1)))
print(aplot, vp=viewport(layout.pos.row=1, layout.pos.col=1))
print(bplot, vp=viewport(layout.pos.row=2, layout.pos.col=1))
print(cplot, vp=viewport(layout.pos.row=3, layout.pos.col=1))
print(trafficplot, vp=viewport(layout.pos.row=4, layout.pos.col=1))

dev.off()