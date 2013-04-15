

# Load packages.
packages <- c("downloader", "ggplot2", "MASS", "reshape", "scales", "splines")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Identify ZIP data.
zip <- "data/htus8008.zip"
# Download ZIP archive.
if(!file.exists(zip)) {
  # Homicide Trends in the United States, 1980-2008.
  url <- "http://bjs.ojp.usdoj.gov/content/pub/sheets/htus8008.zip"
  # Download ZIP archive.
  download(url, zip)
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
qplot(data = bjs, y = Count, x = Year, color = Weapon, geom = "point") +
  geom_line() + ylab("Homicide count") + scale_y_continuous(labels = comma)



# Average homicide count by weapon type.
with(bjs, tapply(Count, Weapon, mean))
# Full summary statistics for each weapon type.
with(bjs, tapply(Count, Weapon, summary))



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



# Different smoother, 3-length knots.
fig + geom_smooth(method = "rlm", formula = y ~ ns(x,3)) + 
  geom_point(alpha = .75, size = 1)


