

# Load packages.
packages <- c("downloader", "ggplot2", "lubridate", "reshape", "scales")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# 
link = "http://www.quandl.com/api/v1/datasets/STATCHINA/E0403.csv?&trim_start=1952-12-31&trim_end=2011-12-31&sort_order=desc"
file = "data/china.txt"
# Download
if(!file.exists(file)) download(link, file, mode = "wb")
# Read data, skipping row numbers.
data <- read.csv(file)
# Fix names.
names(data) <- c("Year", "Active", "Employed", "Primary", "Secondary", "Tertiary",
                 "P1", "P2", "P3")
# Reshape.
data <- melt(data, id = "Year", variable = "Industry")
# Turn years to proper dates.
data$Year <- ymd(data$Year)



# Working population, millions
qplot(data = subset(data, Industry %in% c("Primary", "Secondary", "Tertiary")),
      y = value / 10^2, x = Year, colour = Industry, fill = Industry,
      geom = c("point", "line")) +
  labs(y = "Million Employees")



#
qplot(data = subset(data, Population %in% c("Primary", "Secondary", "Tertiary")),
      y = value / 10^3, x = Year, colour = Population, fill = Population,
      position = "stack", geom = "area") + 
    scale_y_continuous(labels = comma) + labs(y = "Million")


