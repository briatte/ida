

# Load packages.
packages <- c("changepoint", "downloader", "ggplot2", "lubridate", "plyr", "reshape", "XML")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# 
link = "http://www.quandl.com/api/v1/datasets/STATCHINA/E0403.csv?&trim_start=1952-12-31&trim_end=2011-12-31&sort_order=desc"
file = "data/china.sectors.5211.txt"
# Download
if(!file.exists(file)) download(link, file, mode = "wb")
# Read data, skipping row numbers.
data <- read.csv(file, stringsAsFactors = FALSE)
# Fix names.
names(data) <- c("Year", "Active", "Employed", "Primary", "Secondary", "Tertiary",
                 "P1", "P2", "P3")
# Reshape.
data <- melt(data, id = "Year", variable = "Industry")
# Turn years to proper dates.
data$Year <- ymd(data$Year)



# Working population, millions
qplot(data = subset(data, Industry %in% c("Primary", "Secondary", "Tertiary")),
      y = value / 10^2, x = year(Year), colour = Industry, fill = Industry,
      position = "stack", geom = "area") +
  labs(y = "Million Employees")



#
qplot(data = subset(data, Population %in% c("Primary", "Secondary", "Tertiary")),
      y = value / 10^3, x = Year, colour = Population, fill = Population,
      position = "stack", geom = "area") + 
    scale_y_continuous(labels = comma) + labs(y = "Million")



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



g <- qplot(data = data, x = X, y = mu, colour = season, geom = "point") + 
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



cpt <- cpt.mean(data$mu, method = 'PELT')
seg <- data.frame(cpt = attr(cpt, "param.est"))
seg$xmax <- attr(cpt, "cpts")
seg$xmin <- c(0, seg$xmax[-length(seg$xmax)])

g + geom_segment(data = seg, aes(x = xmin, xend = xmax, y = mean, yend = mean), color = "black")



# Load MASS package (provides "rlm" function).
library(MASS)
# Load splines package (provides "ns" function).
library(splines)



g <- qplot(data = data, x = X, y = mu, alpha = I(0.5), geom = "line") + 
  geom_hline(y = mean(data$mu), linetype = "dashed") +
  scale_x_continuous(breaks = seq(1, 156, 22)) +
  labs(y = "Mean rating", x = "Episode")

g + geom_smooth(fill = "steelblue", se = FALSE) + aes(colour = season, y = c(0, diff(mu)))
g + geom_smooth(method="rlm", formula = y ~ ns(x, 8))


