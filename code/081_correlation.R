

# Load downloader package.
require(downloader)
# Target source.
source <- "https://raw.github.com/jeromyanglim/oecd_life_analysis/master/oecd-life.csv"
# Download the dataset.
if(!file.exists(file <- "data/oecd-life.csv"))
  download(source, file, mode = "wb")
# Import the CSV file.
oecd <- read.csv(file, sep = "\t", stringsAsFactors = FALSE)[1:36, ]



# Extract numeric data.
oecd[-1] <- as.numeric(gsub("[^0-9.]", "", as.matrix(oecd[-1])))



# Load countrycode package.
require(countrycode)
# Add country codes.
oecd$iso3c <- countrycode(oecd$COUNTRY, "country.name", "iso3c")
# Check result.
head(oecd)[c(1, 4, 6, 13, 26)]



# Compute average life expectancy.
ymean <- mean(oecd$Life.expectancy)
# Compute average water quality.
xmean <- mean(oecd$Water.quality)
# Plot both variables with country codes as data points.
g <- qplot(data = oecd, y = Life.expectancy, x = Water.quality, 
      label = iso3c, geom = "text") +
  geom_vline(x = xmean, linetype = "dashed") +
  geom_hline(y = ymean, linetype = "dashed")
# Show plot.
g



# Create a dummy denoting positive or negative correlation.
bottom.left <- (oecd$Water.quality < xmean) & (oecd$Life.expectancy < ymean)
top.right   <- (oecd$Water.quality > xmean) & (oecd$Life.expectancy > ymean)
correlation <- ifelse(bottom.left | top.right, "positive", "negative")
# Add colored circles to discriminate the data points.
g + geom_point(size=16, alpha = .4, aes(color = correlation)) +
  scale_colour_manual("Correlation", 
                      values = c("positive" = "green", "negative" = "red")) +
  theme(legend.position = "top")



g + geom_smooth(fill = "green", color = "forestgreen", alpha = .2)



# Correlation coefficient.
with(oecd, cor(Life.expectancy, Water.quality))



# Load arm package.
require(arm)
# Absolute correlation plot.
corrplot(oecd[-c(1, 26)], color = TRUE)



# Compute correlation coefficient.
with(oecd, cor(Life.Satisfaction, Long.term.unemployment.rate, use = "complete.obs"))
# Plot with smoothed trend.
qplot(data = oecd, y = Life.Satisfaction, x = Long.term.unemployment.rate,
      label = iso3c, geom = "text") +
  geom_smooth(fill = "red", color = "darkred", alpha = .2)



# Scatterplot matrix.
pairs(oecd[c(15:17, 25)])
# Load car package.
require(car)
# More sophisticated output.
scatterplotMatrix(oecd[c(15:17, 25)], smoother=NULL)


