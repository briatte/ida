
## IDA Exercise 4
## --------------


# This exercise replicates plots that use Congressional ideal estimation points.
# The code is adapted from examples found at David Sparks' is.R() blog.

# The script uses cross-sectional and then time series to show how aggregating
# basically works. We do not go into functions like ldply() or rbind.fill().


# Packages
# --------

require(downloader)
require(foreign)
require(ggplot2)
require(Hmisc)
require(RColorBrewer)
require(reshape)
require(xlsx)


# Data preparation: Shor's cross-sectional scores (2012)
# ------------------------------------------------------

# Target dataset.
file = "data/bshor.congress.2012.txt"

# Download and convert.
if(!file.exists(file)) {
  # Target file name.
  xlsx = "data/bshor.congress.2012.xlsx"
  # Target file URL.
  url = "http://bshor.files.wordpress.com/2012/10/cands_house2012_boris_shor.xlsx"
  # Download source.
  if(!file.exists(xlsx)) download(url, xlsx)
  # Read XLSX format.
  data = read.xlsx(xlsx, 1)
  # Save CSV format.
  write.csv(data, file, row.names = FALSE)
}

# Read data.
data = read.csv(file)

# Check result.
head(data[, 1:9])


# Aggregating scores by party
# ---------------------------

# Simple aggregation with tapply().
tapply(data$score, data$party, mean)

# The by() version for data frames with factors.
by(data$score, data$party, mean)

# The aggregate() version with formula notation.
aggregate(score ~ party, data = data, FUN = "mean")


# Passing aggregates as graphical options
# ---------------------------------------

# RColorBrewer codes for blue, red, gray.
party.colors = brewer.pal(9, "Set1")[c(2, 1, 9)]
# Stacked distributions, colored by party.
g <- qplot(data = data, x = score, fill = party, colour = party, 
      position = "stack", alpha = I(.75), geom = "density") + 
  scale_fill_manual("Party", values = party.colors) +
  scale_colour_manual("Party", values = party.colors)
g


# Data preparation: DW-NOMINATE time series (1-111th Congress)
# ------------------------------------------------------------

# Target dataset.
file = "data/dwnominate.txt"

# Download and convert.
if(!file.exists(file)) {
  # Target file name.
  dta = "data/dwnominate.dta"
  # Target file URL.
  url = "ftp://voteview.com/junkord/HL01111E21_PRES.DTA"
  # Download source.
  if(!file.exists(xlsx)) download(url, dta)
  # Read XLSX format.
  dw = read.dta(dta)
  # Save CSV format.
  write.csv(dw, file, row.names = FALSE)
}

# Read data.
dw = read.csv(file)

# Check result.
head(dw[, 1:9])

# Recode party variable.
dw$majorParty = "Other"
dw$majorParty[dw$party == 100] = "Democrat"
dw$majorParty[dw$party == 200] = "Republican"


# Aggregating scores by party
# ---------------------------

# Raw frequencies (N) by party.
table(dw$majorParty)

# Mean DW-NOMINATE score by party.
with(dw, tapply(dwnom1, majorParty, mean))

# Quicker syntax for data frames.
aggregate(dwnom1 ~ majorParty, dw, mean)

# Slightly more verbose syntax.
with(dw, by(dwnom1, majorParty, mean))

# David Sparks' transformation to session-party measurements, using plyr for the
# ddply() function and Hmisc for the weighted wtd.functions (very neatly coded).
dw.aggregated <- ddply(.data = dw,
                       .variables = .(cong, majorParty),
                       .fun = summarise,
                       Median = wtd.quantile(dwnom1, 1/bootse1, 1/2),
                       q25 = wtd.quantile(dwnom1, 1/bootse1, 1/4),
                       q75 = wtd.quantile(dwnom1, 1/bootse1, 3/4),
                       q05 = wtd.quantile(dwnom1, 1/bootse1, 1/20),
                       q95 = wtd.quantile(dwnom1, 1/bootse1, 19/20),
                       N = length(dwnom1))

# Create levels for the major party variable.
l = c("Republican", "Democrat", "Other")
# Convert the major party variable to factor.
dw.aggregated$majorParty <- factor(dw.aggregated$majorParty, levels = l)

# All statistics, calculated "by" the .variables from the ddply() function, i.e.
# time (Congressional session, cong) and partisan space (majorParty). It rocks.
head(dw.aggregated)

# Median DW-NOMINATE score of parties in the 111th Congress.
dw.aggregated[dw.aggregated$cong == 111, ]


# Passing aggregates as graphical options
# ---------------------------------------

# David Sparks' neat, simple, clean plot of ideological distributions.
p = ggplot(dw.aggregated,
              aes(x = cong, y = Median, ymin = q05, ymax = q95,
                  colour = majorParty, alpha = N))

p = p +
  # Plot the 90% CI, inheritting x, y, colour and alpha.
  geom_linerange(aes(ymin = q25, ymax = q75), size = 1) +
  # Plot the IQR.
  geom_pointrange(size = 1/2) +
  # Add colors.
  scale_colour_brewer(palette = "Set1") +
  # Add titles.
  labs(title = "Congressional ideological distribution", x = NULL)

# View result.
p


# David Sparks has more great stuff at his is.R() blog. I ain't paid to say it.
# 2013-05-13
