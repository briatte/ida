## by David Ruau

library(twitteR)

n <- 27
feed <- userTimeline("BeijingAir", n = n)
sfeed <- lapply(feed, function(x) strsplit(x$getText(), "; ", fixed = TRUE))
times <- vector("list", length = n)
pm25 <- numeric(n)
times <- sapply(sfeed, function(x) {
  paste(x[[1]][1:2], collapse = " ")
})
times <- strptime(times, "%m-%d-%Y %H:%M")
pm25 <- sapply(sfeed, function(x) {
  x <- x[[1]]
  if(length(grep("^Past", x[3])) > 0)
    return(NA)
  as.numeric(x[4])
})
u <- !is.na(pm25)
times <- times[u]
pm25 <- pm25[u]

png(file = "beijing24.png", width = 700, height = 480)
par(mar = c(2, 4.5, 2, 1) + .1)
plot(times, pm25, main = expression(PM[2.5] * " in Beijing"),
     xlab = "", ylab = expression(PM[2.5] * " (" * mu * g/m^3 * ")"),
     pch = 19, type = "b")
dev.off()

## by Roger D. Peng:

library(twitteR)
library(ggplot2)
library(grid)
 
# download all that you can
pol <- userTimeline('BeijingAir', n=3200)
length(pol)
# 3200
 
myGrep <- function(x){
  grep("PM2.5 24hr avg;", x$getText(), value=T)
}
 
POL <- unlist(lapply(pol, myGrep))
# cleaning no data tweets
POL <- POL[-grep("No Data", POL)]
# uncomment the following to combine with previous extract
# allPM <- unique(c(allPM, POL))
allPM <- POL
time <- sub("^(.*) to .*", "\\1", allPM)
# to posix time
time <- strptime(time, format="%m-%d-%Y %R")
PM <- as.numeric(sub("^.* 24hr avg; (.*); .*; .*", "\\1", allPM, perl=T))
data <- data.frame(PM=PM, time=time)
data <- data[order(data$time),]
yrange <- c(25, 75, 125, 175, 250, 400)
tsize=4
min(data$time)
# [1] "2012-04-08 PDT"
textPos <- as.POSIXct("2012-04-12")
p <- qplot(time, PM, data=data, geom=c("blank"), group=1)
p + 
labs(x = "Time", y = "Fine particles (PM2.5) 24hr avg", size = expression(log[10](pval))) +
opts(title="Air pollution in Beijing\nTwitter @BeijingAir", panel.background=theme_rect(colour="white")) +
geom_hline(aes(yintercept=50), colour="green", alpha=I(1/5), size=2) +
geom_hline(aes(yintercept=100), colour="yellow", alpha=I(1/5), size=2) +
geom_hline(aes(yintercept=150), colour="orange", alpha=I(1/5), size=2) +
geom_hline(aes(yintercept=200), colour="red", alpha=I(1/5), size=2) +
geom_hline(aes(yintercept=300), colour="darkred", alpha=I(1/5), size=2) +
geom_path(aes(time, PM), data=data, group=1) +
annotate("text", x=textPos, y=yrange[1], label="good", size=tsize, colour="grey70") +
annotate("text", x=textPos, y=yrange[2], label="moderate", size=tsize, colour="grey70") +
annotate("text", x=textPos, y=yrange[3], label="unhealthy", size=tsize, colour="grey70") +
annotate("text", x=textPos, y=yrange[4], label="unhealthy +", size=tsize, colour="grey70") +
annotate("text", x=textPos, y=yrange[5], label="unhealthy ++", size=tsize, colour="grey70") +
annotate("text", x=textPos, y=yrange[6], label="hazardous", size=tsize, colour="grey70") +
opts(title="Air pollution in Beijing\nTwitter @BeijingAir",
 panel.background=theme_rect(colour="white"))
 
ggsave(filename="twitter_pol.png")
