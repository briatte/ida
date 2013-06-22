

# Load packages.
packages <- c("changepoint", "downloader", "ggplot2", "MASS", "reshape", "splines", "XML")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



file = "data/geos.tww.txt"
if(!file.exists(file)) {
  # Parse HTML content.
  html <- htmlParse("http://www.geos.tv/index.php/list?sid=179&collection=all")
  # Select table on id.
  html <- xpathApply(html, "//table[@id='collectionTable']")[[1]]
  # Convert to dataset.
  data <- readHTMLTable(html)
  # First data rows.
  head(data)
  # Save local copy.
  write.csv(data[, -3], file, row.names = FALSE)
}
# Read local copy.
data <- read.csv(file, stringsAsFactors = FALSE)
# Check result.
str(data)



# Convert means from text.
data$mu <- as.numeric(substr(data$Mean, 0, 4))
# Compute standard errors.
data$se <- with(data, sd(mu) / sqrt(as.numeric(Count)))



# Compute season.
data$season <- 1 + (data$X - 1) %/% 22
# Fix special cases.
data$season[which(data$season > 7)] <- c(7, NA)
# Factor variable.
data$season <- factor(data$season)



g = qplot(data = data, x = X, y = mu, colour = season, geom = "point") + 
  geom_linerange(aes(ymin = mu - 1.96*se, ymax = mu + 1.96*se), alpha = .5) +
  geom_linerange(aes(ymin = mu - 2.58*se, ymax = mu + 2.58*se), alpha = .5) +
  scale_colour_brewer("Season", palette = "Set1") +
  scale_x_continuous(breaks = seq(1, 156, 22)) +
  theme(legend.position = "top") +
  labs(y = "Mean rating", x = "Episode")
g



# Compute season means.
means <- ddply(data, .(season), summarise, 
      mean = mean(mu), 
      xmin = min(X), 
      xmax = max(X))
# Add means to plot.
g + geom_segment(data = means, 
                 aes(x = xmin, xend = xmax, y = mean, yend = mean))



# Compute changepoints with PELT algorithm.
cpt <- cpt.mean(data$mu, method = 'PELT')
# Extract results.
seg <- data.frame(cpt = attr(cpt, "param.est"))
seg$xmax <- attr(cpt, "cpts")
seg$xmin <- c(0, seg$xmax[-length(seg$xmax)])
# Plot.
g + geom_segment(data = seg, 
                 aes(x = xmin, xend = xmax, y = mean, yend = mean), 
                 color = "black")



# General plot function.
g = qplot(data = data,
          x = X,
          y = mu,
          alpha = I(0.5),
          geom = "line") + 
  scale_x_continuous(breaks = seq(1, 156, 22)) +
  labs(y = "Mean rating", x = "Episode")



# LOESS smoother for each season.
g + 
  geom_smooth(se = FALSE) + 
  geom_hline(y = mean(data$mu), linetype = "dashed") +
  aes(colour = season)
# LOESS smoother for the detrended values.
g + 
  geom_smooth(se = FALSE) + 
  geom_hline(aes(y = mean(diff(mu))), linetype = "dashed") +
  aes(colour = season, y = c(0, diff(mu)))
# Cubic splines for the full series.
g + 
  geom_smooth(method = "rlm", se = FALSE, formula = y ~ ns(x, 8)) +
  geom_hline(y = mean(data$mu), linetype = "dashed")



# Cubic splines and changepoints.
g + 
  geom_smooth(method = "rlm", se = FALSE, formula = y ~ ns(x, 8)) +
  geom_hline(y = mean(data$mu), linetype = "dashed") + 
  geom_segment(data = seg, 
               aes(x = xmin, xend = xmax, y = mean, yend = mean), 
               color = "black")


