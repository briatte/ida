

# Identify ZIP data.
zip <- "data/htus8008.zip"
# Download ZIP archive.
if(!file.exists(zip)) {
  # Homicide Trends in the United States, 1980-2008.
  url <- "http://bjs.ojp.usdoj.gov/content/pub/sheets/htus8008.zip"
  # Download ZIP archive.
  download.file(url, zip)
}
# Unzip directory.
if(!file.exists("data/htus8008")) {
  unzip(zip, exdir = "data/htus8008")
}



# Read some data as CSV.
bjs <- read.csv("data/htus8008/htus8008f42.csv", skip = 11, nrows = 29)
# Remove last column.
bjs <- bjs[,1:6]
# Check first rows.
head(bjs)
# Check final rows.
tail(bjs)



# Clean names.
names(bjs) <- gsub("\\.", " ", names(bjs))
# Check result.
names(bjs)



# Load reshape2 library.
library(reshape2)
# Reshape to long format.
bjs <- melt(bjs, id = "Year")
# Check result.
head(bjs)
# Rename variables.
names(bjs) <- c("Year", "Weapon", "Count")
# Inspect weapon types.
levels(bjs$Weapon)
# Order weapon type by homicide count.
bjs$Weapon <- with(bjs, reorder(Weapon, -Count, mean))



# Plot canvas.
fig <- ggplot(bjs, aes(y = Count, x = Year))
# Plot weapon types.
fig <- fig + geom_line(aes(color = Weapon)) 
# Plot y-title.
fig <- fig + ylab("Homicide count")
# Check result.
fig



# Load scales package.
library(scales)
# Add commas to y-axis
fig <- fig + scale_y_continuous(labels = comma)
# Check result.
fig



# Average homicide count by weapon type.
with(bjs, tapply(Count, Weapon, mean))
# Full summary statistics for each weapon type.
with(bjs, tapply(Count, Weapon, summary))



# Load plyr package.
library(plyr)
# Mean and median of homicide counts by weapon type.
tbl <- ddply(bjs, .(Weapon), summarize, Mean = mean(Count), Median = median(Count))
# Check result.
tbl



# Plot canvas.
fig <- ggplot(bjs, aes(y = Count, x = Year, group = Weapon, color = Weapon, fill = Weapon))
# Plot titles and scales.
fig <- fig + scale_y_continuous(labels = comma) + ylab("Homicide count")



# Add a LOESS curve.
fig + geom_smooth()
# Add faded data points.
fig + geom_smooth() + geom_point(alpha = I(.3))



# Load MASS package (provides "rlm" function).
library(MASS)
# Load splines package (provides "ns" function).
library(splines)
# Different smoother, 3-length knots.
fig + geom_smooth(method="rlm", formula = y ~ ns(x,3))



library(RCurl)
library(ggplot2)
library(reshape2)

if(!file.exists("data/unodc2010_extract.csv")) {
  # Get raw data.
  unodc <- getURL("http://www.quantumforest.com/wp-content/uploads/2012/02/homicides.csv", .encoding="UTF-8")
  # Turn to text.
  unodc <- textConnection(unodc)
  # Read lines.
  unodc <- readLines(unodc)
  # Convert to CSV.
  unodc <- read.csv(text = unodc)
  # Check for folder.
  if(!file.exists("data")) dir.create("data")
  # Save as CSV.
  write.csv(unodc, file = "data/unodc2010_extract.csv", row.names = FALSE)
}

# Read as CSV.
unodc <- read.csv("data/unodc2010_extract.csv")
# Check first rows.
head(unodc)
# Check final rows.
tail(unodc)
# Plot main distribution.
qplot(unodc$rate, geom = "histogram", bin = 5) + xlab("Distribution of homicide rates") + ylab("N")



# Load the plyr library.
library(plyr)
# Mean and median of homicide counts.
tbl <- ddply(unodc, .(country), summarise, mean = round(mean(rate, na.rm = TRUE),1), min = min(rate, na.rm = TRUE), max = max(rate, na.rm = TRUE))
# Check result.
tbl



# Load the reshape2 library.
library(reshape2)
# Reorder levels.
tbl$country <- with(tbl, reorder(country, mean))
# Plot it.
fig <- ggplot(tbl, aes(x = country, y = mean, ymin = min, ymax = max))
# Add pointrange lines.
fig <- fig + geom_pointrange()
# Pivot graph.
fig <- fig + coord_flip()
# Add titles.
fig <- fig + ylab("Homicide rates 1995-2010\n(min-max ranges, dot at mean)") + xlab("")
# Add minimum and maximum on the plot.
fig + 
  geom_text(label = round(tbl$max, 0), y = tbl$max, hjust = -.25, size = 4) + 
  geom_text(label = round(tbl$min, 0), y = tbl$min, hjust = 1.25, size = 4)
# Heatmap.
ggplot(unodc, aes(x = year, y = country, fill = rate)) + geom_tile() + scale_fill_gradient(low="white", high="red", name = "Homicide rate") + theme_bw()



# Load MASS package (provides "rlm" function).
library(MASS)
# Load splines package (provides "ns" function).
library(splines)
# Plot canvas.
fig <- ggplot(unodc, aes(y = rate, x = year, group = country, color = country, fill = country))
# Spline, 2-length knots.
fig <- fig + geom_smooth(method="rlm", formula = y ~ ns(x, 2), alpha = .25)
# Check result.
fig + ylab("Homicide rate per 100,000 population") + xlab("Year")


