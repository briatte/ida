

# Load packages.
packages <- c("downloader", "ggplot2", "plyr", "reshape", "scales")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



dat <- read.csv("data/CSHomePrice_History.csv")
write.csv(dat, "data/schiller.8712.csv", row.names = FALSE)



# Open the data.
csi <- read.csv("data/schiller.8712.csv")
# Inspect the top data structure.
str(csi[, 1:5])
# Inspect the first data rows/columns.
head(csi[, 1:5])



# Collapse the data by years.
csi.melted <- melt(csi, id = "YEAR")
# Name the columns.
names(csi.melted) <- c("MonthYear", "City", "IndexValue")



# Convert dates.
csi.melted$Date <- as.Date(paste0("01-", csi.melted$MonthYear), "%d-%b-%y")



# Build line plot.
g1 <- ggplot(data = csi.melted, aes(x = Date, y = IndexValue)) +
  geom_line(aes(color = City), size = 1.25) +
  labs(x = NULL, y = "Case Schiller Index")
# View result.
g1



# Select only a handful of states.
cities = c('NY.New.York', 'FL.Miami', 'CA.Los Angeles', 'MI.Detroit', 
           'TX.Dallas', 'IL.Chicago', 'DC.Washington')
# Create a subset of the data.
csi.subset = subset(csi.melted, City %in% cities)
# Build plot.
g2 <- ggplot(data = csi.subset, aes(x = Date, y = IndexValue)) +
  geom_line(aes(color = City), size = 1.25) +
  labs(x = NULL, y = "Case Schiller Index")
# View result.
g2



# Identify ZIP data.
zip = "data/htus8008.zip"
# Download ZIP archive.
if(!file.exists(zip)) {
  # Target data source.
  url = "http://bjs.ojp.usdoj.gov/content/pub/sheets/htus8008.zip"
  # Download ZIP archive.
  download(url, zip, mode = "wb")
}
# Identify ZIP folder.
dir = "data/htus8008"
# Unzip archive.
if(!file.exists(dir)) unzip(zip, exdir = dir)



# Read some data as CSV.
bjs <- read.csv("data/htus8008/htus8008f42.csv", skip = 11, nrows = 29)
# Inspect the data.
str(bjs)
# Remove last column.
bjs <- bjs[, -7]
# Clean names.
names(bjs) <- gsub("\\.", " ", names(bjs))
# Check first rows.
head(bjs)
# Check final rows.
tail(bjs)



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
qplot(data = bjs, y = Count, x = Year, color = Weapon,
      geom = c("line", "point")) +
  labs(y = "Homicide count", x = NULL) +
  scale_y_continuous(labels = comma)



# Average homicide count by weapon type, using with() and tapply().
with(bjs, tapply(Count, Weapon, mean))
# Similar syntax with by() to get quintiles of homicide counts by weapon type.
by(bjs$Count, bjs$Weapon, quantile)



# aggregate()'s formula notation of the form variable ~ group.
aggregate(Count ~ Weapon, bjs, summary)
# ddply()'s more demanding syntax offers more functionality.
ddply(bjs, .(Weapon), summarise,
      N    = length(Count),
      Mean = mean(Count),
      SD   = sd(Count),
      Min  = min(Count),
      Max  = max(Count))


