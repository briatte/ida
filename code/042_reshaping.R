

library(foreign)
library(Hmisc)

if (file.exists("data/dwnominate.dta")) {
  # Open local copy.
  dwNominate <- read.dta("data/dwnominate.dta")
} else {
  print("Cannot find dataset, loading from web...")
  # Retrieve file.
  dwNominate <- read.dta("ftp://voteview.com/junkord/HL01111E21_PRES.DTA")
  # Save local copy.
  write.dta(dwNominate, file = "data/dwnominate.dta")
}

# Make a re-coded party variable
dwNominate$majorParty <- "Other"
dwNominate$majorParty[dwNominate$party == 100] <- "Democrat"
dwNominate$majorParty[dwNominate$party == 200] <- "Republican"

# Have a look.
head(dwNominate)



library(plyr)
# Letting plyr do the work for us (the weighted wtd.functions are from Hmisc)
aggregatedIdeology <- ddply(.data = dwNominate,
                            .variables = .(cong, majorParty),
                            .fun = summarise,
                            Median = wtd.quantile(dwnom1, 1/bootse1, 1/2),
                            q25 = wtd.quantile(dwnom1, 1/bootse1, 1/4),
                            q75 = wtd.quantile(dwnom1, 1/bootse1, 3/4),
                            q05 = wtd.quantile(dwnom1, 1/bootse1, 1/20),
                            q95 = wtd.quantile(dwnom1, 1/bootse1, 19/20),
                            N = length(dwnom1))

# Convert the major party variable to a factor variable.
aggregatedIdeology$majorParty <- factor(aggregatedIdeology$majorParty,
                                        levels = c("Republican", "Democrat", "Other"))

# All of our stats, calculated "by" our .variables.
head(aggregatedIdeology)



# Neat, simple, clean plot of ideological distributions
zp1 <- ggplot(aggregatedIdeology,
              aes(x = cong, y = Median,
                  ymin = q05, ymax = q95,
                  colour = majorParty, alpha = N))
# Plot the 90% CI, inheritting x, y, colour and alpha
zp1 <- zp1 + geom_linerange(aes(ymin = q25, ymax = q75), size = 1)
zp1 <- zp1 + geom_pointrange(size = 1/2)  # Plot the IQR
zp1 <- zp1 + scale_colour_brewer(palette = "Set1")
zp1 <- zp1 + theme_bw()
print(zp1)



# Open the data.
dat <- read.csv("data/CSHomePrice_History.csv")



# Inspect the data structure.
str(dat)
# Inspect the first data rows.
head(dat)



# Load packages.
library(reshape)
# Collapse the data by years.
mdf <- melt(dat, id = "YEAR")
# Name the columns.
names(mdf) <- c("MonthYear", "City", "IndexValue")



# Convert dates.
mdf$Date <- as.Date(paste0("01-", mdf$MonthYear), "%d-%b-%y")



(fig.all <- ggplot(data=mdf, aes(x=Date, y=IndexValue)) +
geom_line(aes(color=City), size=1.25) +
scale_x_date("Year") + scale_y_continuous("Case Schiller Index"))



# Keep only a handful of states.
sm=subset(mdf,City %in% c('NY.New.York','FL.Miami','CA.Los Angeles','MI.Detroit',
                          'TX.Dallas','IL.Chicago','DC.Washington'))
# Remove levels.
sm$City=droplevels(sm$City)
# Final plot.
(fig.subset <- ggplot(data=sm, aes(x=Date, y=IndexValue)) +
  geom_line(aes(color=City),size=1.5) +
  scale_x_date("Year") + scale_y_continuous("Case Schiller Index"))


