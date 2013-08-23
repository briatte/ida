

# Nine random numbers.
x = runif(9)
# Play heads or tails.
ifelse(x > .5, "Heads", "Tails")



# Load packages.
packages <- c("downloader", "ggplot2", "plyr", "reshape", "xlsx")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Set file locations.
link = "http://www.minneapolisfed.org/publications_papers/studies/recession_perspective/data/historical_recessions_recoveries_data_05_03_2013.xls"
file = "data/us.recessions.4807.xls"
data = "data/us.recessions.4807.csv"
# Download the data.
if(!file.exists(data)) {
  if(!file.exists(file)) download(link, file, mode = "wb")
  file <- read.xlsx(file, 1, startRow = 8, endRow = 80, colIndex = 1:12)
  # Fix variable names.
  year = c(1948, 1953, 1957, 1960, 1969, 1973, 1980, 1981, 1990, 2001, 2007)
  names(file) = c("t", year)
  write.csv(file, data, row.names = FALSE)
}
# Load the data.
data <- read.csv(data, stringsAsFactors = FALSE)
# Fix variable names.
names(data)[-1] <- gsub("X", "", names(data)[-1])
# Inspect the data.
str(data)



# Reshape data to long format, by year.
data = melt(data, id = "t", variable = "recession.year")
head(data)
# Extract last value, by melted series.
text = ddply(na.omit(data), .(recession.year), summarise, 
             x = max(t) + 1,
             y = tail(value)[6])
head(text)



# Plot recession lines.
gg.base = qplot(data = data, 
                x = t, 
                y = value, 
                group = recession.year, 
                geom = "line")
# Plot 2007 recession in red.
gg.2007 = geom_line(data = subset(data, recession.year == 2007), 
                    color = "red", 
                    size = 1)
# Plot recession year labels.
gg.text = geom_text(data = text, 
                    aes(x = x, y = y, label = recession.year), 
                    hjust = 0,
                    color = ifelse(text$recession.year == 2007, "red", "black"))
# Plot zero-line.
gg.line = geom_hline(y = 0, linetype = "dashed")
# Define y-axis.
gg.axis = scale_x_continuous("Months after peak", lim = c(0, 75))
# Define y-label.
gg.ylab = labs(y = "Cumulative decline from NBER peak")
# Build plot.
gg.base + 
  gg.2007 + 
  gg.text + 
  gg.line + 
  gg.axis + 
  gg.ylab  


