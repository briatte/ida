

source("code/4_congress.R")



# Check result.
head(data[, 1:9])



# The naive approach: loop over levels, subset the data, compute the scores.
for(i in levels(data$party)) {
  # Create a subset of the data for that party.
  d = subset(data, party == i)
  # Compute the mean ideal estimate point.
  cat(i, nrow(d), mean(d$score, na.rm = TRUE), "\n")
}



# Simple aggregation with tapply().
tapply(data$score, data$party, mean)
# The by() version for data frames with factors.
by(data$score, data$party, mean)
# The aggregate() version with formula notation.
aggregate(score ~ party, data = data, FUN = "mean")



sapply(levels(data$party), function(x) { 
  this.party = which(data$party == x)
  mean(data$score[this.party]) })



# RColorBrewer codes for blue, red, gray.
party.colors = brewer.pal(9, "Set1")[c(2, 1, 9)]
# Stacked distributions, colored by party.
qplot(data = data, x = score, fill = party, colour = party, 
      position = "stack", alpha = I(.75), geom = "density") + 
  scale_fill_manual("Party", values = party.colors) +
  scale_colour_manual("Party", values = party.colors)



# Raw frequencies (N) by party.
table(dw$majorParty)
# Mean DW-NOMINATE score by party.
aggregate(dwnom1 ~ majorParty, dw, mean)



# David Sparks' transformation to session-party measurements, using plyr for the
# ddply() function and Hmisc for the weighted wtd.functions.
dw.aggregated <- ddply(.data = dw,
                       .variables = .(cong, majorParty),
                       .fun = summarise,
                       Median = wtd.quantile(dwnom1, 1/bootse1, 1/2),
                       q25 = wtd.quantile(dwnom1, 1/bootse1, 1/4),
                       q75 = wtd.quantile(dwnom1, 1/bootse1, 3/4),
                       q05 = wtd.quantile(dwnom1, 1/bootse1, 1/20),
                       q95 = wtd.quantile(dwnom1, 1/bootse1, 19/20),
                       N = length(dwnom1))



# Median DW-NOMINATE score of parties in the 111th Congress.
dw.aggregated[dw.aggregated$cong == 111, ]



p


