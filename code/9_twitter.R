
## David Ruau's code to scrape and plot Beijing air pollution:
## http://brainchronicle.blogspot.co.uk/2012/07/twitter-analysis-of-air-pollution-in.html

## The code was adapted for the Twitter 1.1 API, which now requires ROAuth.
## You will first need to include individual consumer keys at '--------' to run it.

require(twitteR)
require(ROAuth)
require(ggplot2)
require(grid)

## ROAuth.
cred <- OAuthFactory$new(consumerKey= "--------",
	consumerSecret= "--------",
	requestURL="https://api.twitter.com/oauth/request_token",
	accessURL="https://api.twitter.com/oauth/access_token",
	authURL="https://api.twitter.com/oauth/authorize")
cred$handshake()
registerTwitterOAuth(cred)

## Back to David Ruau's code.
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
textPos <- as.POSIXct(strsplit(as.character(min(data$time)), " ")[[1]][1])

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
 
## saving image of full workspace for reference
save.image("data/beijing.aqi.2013.rda")

## use this file to show the teaching examples:
write.csv(data, "data/beijing.aqi.2013.csv", row.names = FALSE)

head(data)

## data produced in May 2013
## have a nice day
