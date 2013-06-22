# http://plausibel.blogspot.fr/2013/01/public-and-public-plus-private-debt-to.html

require(RCurl)
library(reshape)
library(ggplot2)
require(stringr)

#
#
# Data from Thomas Herndon et al.
url = "http://www.peri.umass.edu/fileadmin/pdf/working_papers/working_papers_301-350/"
zip = "HAP-RR-GITD-code.zip"

#
#
# Target disk location.
dta = paste0("data/", zip)
# Fetch ZIP file.
if(!file.exists(dta)) download(paste0(url, zip), dta)
# Extract DTA file.
ppd  <- read.dta(unzip(dta, exdir = "data/", files = "RR-processed.dta"))

#
#
# Target disk file.
file = "data/reinhart.rogoff.txt"
# Save CSV replication dataset.
if(!file.exists(file)) write.csv(ppd, file)

#
#
# Split years into decades.
ppd$decade <- 1940 + 10 * floor((ppd$Year - 1940) / 10)

# Split debt-to-GDP ratio by groups.
ppd$dgcat.lm <- cut(ppd$debtgdp, breaks = c(0, 30, 60, 90, Inf))

ppd$dgcat <- factor(cut(ppd$debtgdp, breaks = c(0, 30, 60, 90, Inf)),
                    labels = c("0-30%", "30-60%", "60-90%", "Above 90%"),
                    ordered = TRUE)

# One issue of the RR study has to do with how the data were selected and then
# grouped. Let's take the most compact version of the data (four GDP growth buckets, early decades combined).

# Inspect crosstabulation.
with(ppd, table(decade, dgcat))

# Group 1940s and 1950s.
ppd$decade <- ifelse(ppd$decade <= 1950, 1950, ppd$decade)

p <- qplot(data = ppd, x = Year, y = dRGDP, size = I(1), geom = "point") +
  geom_violin(aes(x = decade, group = decade), fill = "grey", colour = "grey", alpha = I(.5)) +
  geom_point(aes(x = decade), fill = "grey", colour = "grey", alpha = I(.5)) +
  facet_wrap(~ dgcat) + geom_hline(y = mean(ppd$dRGDP, na.rm = TRUE), linetype = "dashed")
p

# Linear trend, 95% CI.
p + geom_smooth(aes(x = Year), fill = "red", colour = "red", method = "lm")

# LOESS smoother, 95% CI.
p + geom_smooth(aes(x = Year), fill = "steelblue", colour = "steelblue")

# Cubic splines, 3 slices
p + geom_smooth(aes(x = Year), fill = "steelblue", colour = "steelblue",
                method = "rlm", formula = y ~ ns(x, 5))

# Cutoff points.
attr(ns(ppd$Year, 5), "knots")

## PRACTICE
qplot(data = ppd, x = Year, y = dRGDP, colour = dgcat, fill = dgcat, 
      method = "rlm", formula = y ~ ns(x, 1), geom = "smooth") +
  geom_hline(y = mean(ppd$dRGDP, na.rm = TRUE), linetype = "dashed") +
  scale_fill_brewer(palette = "Set1") + scale_colour_brewer(palette = "Set1")

qplot(data = ppd, x = Year, y = dRGDP, colour = dgcat, fill = dgcat, 
      method = "rlm", formula = y ~ ns(x, 2), geom = "smooth") +
  geom_hline(y = mean(ppd$dRGDP, na.rm = TRUE), linetype = "dashed") +
  scale_fill_brewer(palette = "Set1") + scale_colour_brewer(palette = "Set1")

qplot(data = ppd, x = Year, y = dRGDP, colour = dgcat, fill = dgcat, 
      method = "rlm", formula = y ~ ns(x, 3), geom = "smooth") +
  geom_hline(y = mean(ppd$dRGDP, na.rm = TRUE), linetype = "dashed") +
  scale_fill_brewer(palette = "Set1") + scale_colour_brewer(palette = "Set1")
