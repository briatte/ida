#
# PACKAGES
#
packages <- c("downloader", "ggplot2", "maps", "scales")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})

# The example below is based on an online tutorial by David Sparks. It shows how
# to map U.S. state-level electoral data collected by David Wasserman.

#
# DATA
#

# Address of a copy of David Wasserman's spreadsheet, cleaned up.
dw_link <- "https://docs.google.com/spreadsheet/pub?key=0Agz-ZYJ5rH_WdHUxMkY3V0lua1VWd3V3RW9EemRpMFE&output=csv"
# Download the spreadsheet.
download(dw_link, file <- "data/wasserman.csv", mode = "wb")
# Transform the result into a proper dataset, leaving text variables (strings) unchanged.
dw_data <- read.csv(file, stringsAsFactors = TRUE)
# Check result.
head(dw_data)

# Create marker for battleground states.
dw_data$Swing <- "Non-Swing State"
# Mark first twelve states (defined as swing states in the data source).
dw_data$Swing[1:12] <- "Swing State"
# Check result.
dw_data[1:15,]

# Two-party margins of victory.
dw_data  <- within(dw_data, {
  Margin08 <- 100 * ((Obama08 - McCain08) / (Obama08 + McCain08))
  Margin12 <- 100 * ((Obama12 - Romney12) / (Obama12 + Romney12))
})
# Check results.
summary(dw_data$Margin08)
summary(dw_data$Margin12)

#
# MAP
#

# Load state shapefiles.
stateShapes <- map("state", plot = FALSE, fill = TRUE)
# Convert shapes to a data frame.
stateShapes <- fortify(stateShapes)  

# Extract states from the map dataset.
uniqueStates <- sort(unique(stateShapes$region))
# Subset the data to those states.
dw_data <- subset(dw_data, tolower(State) %in% uniqueStates)
# Add 2008 margin of victory to the map dataset.
stateShapes$ObamaVote08 <- by(dw_data$Margin08, uniqueStates, mean)[stateShapes$region]
# Add 2012 margin of victory to the map dataset.
stateShapes$ObamaVote12 <- by(dw_data$Margin12, uniqueStates, mean)[stateShapes$region]

# Choropleth map for 2012.
p <- ggplot(stateShapes, aes(x = long, y = lat, group = group, fill = ObamaVote12))
p <- p + geom_polygon(colour = "black")
p <- p + coord_map(project = "conic", lat0 = 30)
p <- p + scale_fill_gradient2("Obama margin\nof victory, 2012", limits=c(-50, 50), high=muted("green"))
p <- p + ggtitle("2012 Election Returns by State\n")
print(p)

# Produce the same map for 2008 and look for differences in the geographical
# distribution of Obama margins of victory. How else could you visualize it?
