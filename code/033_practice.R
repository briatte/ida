

source("code/3_hhi.R")



# HHI function.
hhi



# Load packages.
require(ggplot2)
require(reshape)
require(XML)



# Target file.
file <- "data/browsers.0813.txt"
# Load the data.
if(!file.exists(file)) {
  # Target a page with data.
  url <- "http://en.wikipedia.org/wiki/Usage_share_of_web_browsers"
  # Get the StatCounter table.
  tbl <- readHTMLTable(url, which = 16, as.data.frame = FALSE)
  # Extract the data.
  data <- data.frame(tbl[-7])
  # Clean numbers.
  data[-1] <- as.numeric(gsub("%", "", as.matrix(data[-1])))
  # Clean names.
  names(data) <- gsub("\\.", " ", names(data))
  # Normalize.
  data[-1] <- data[-1] / 100
  # Format dates.
  data[, 1] <- paste("01", data[, 1])
  # Check result.
  head(data)
  # Save.
  write.csv(data, file, row.names = FALSE)
}



# Load from CSV.
data <- read.csv(file)
# Convert dates.
data$Period <- strptime(data$Period, "%d %B %Y")
# Check result.
head(data)



# Normalized Herfindhal-Hirschman Index.
HHI <- (rowSums(data[2:6]^2) - 1 / ncol(data[2:6])) / (1 - 1/ncol(data[2:6]))
# Form a dataset by adding the dates.
HHI <- data.frame(HHI, Period = data$Period)



# Reshape.
melt <- melt(data, id = "Period", variable = "Browser")
# Plot the HHI through time.
ggplot(melt, aes(x = Period)) + labs(y = NULL, x = NULL) +
  geom_area(aes(y = value, fill = Browser), 
            color = "white", position = "stack") + 
  geom_smooth(data = HHI, aes(y = HHI, linetype = "HHI"), 
              se = FALSE, color = "black", size = 1) +
  scale_fill_brewer("Browser\nusage\nshare\n", palette = "Set1") +
  scale_linetype_manual(name = "Herfindhal-\nHirschman\nIndex\n", 
                        values = c("HHI" = "dashed"))


