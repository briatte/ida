

# Load packages.
packages <- c("ggplot2", "lubridate", "plyr", "reshape", "RColorBrewer", "RCurl")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Target data link.
link = "https://docs.google.com/spreadsheet/pub?key=0AonYZs4MzlZbcGhOdG0zTG1EWkVPOEY3OXRmOEIwZmc&output=csv"
# Target data file.
file = "data/icm-polls.txt"



# Download dataset.
if (!file.exists(file)) {
  message("Dowloading the data...")
  # Download and read HTML spreadsheet.
  html <- textConnection(getURL(link, ssl.verifypeer = FALSE))
  # Convert and export CSV spreadsheet.
  write.csv(read.csv(html), file)
}
# Open file.
icm <- read.csv(file, stringsAsFactors = FALSE)
# Check result.
str(icm)



# Clean percentages.
icm[, 3:7] <- as.numeric(gsub("%", "", as.matrix(icm[, 3:7])))
# Check result.
str(icm)



# Mark general elections.
icm$GE <- grepl("RESULT", icm$Sample)
# Check result.
icm[icm$GE, 2:6]



# Convert dates.
icm$Date <- dmy(icm$End.of.fieldwork..election.date)
# Check result.
str(icm)



# List polling years.
table(year(icm$Date))
# List general election years.
table(year(icm$Date[icm$GE]))
# List general election months.
table(month(icm$Date[icm$GE], label = TRUE))



# Subset data.
icm <- icm[, c("Date", "GE", "CON", "LAB", "LIB.DEM", "OTHER")]
# Drop missing data.
icm <- na.omit(icm)
# Reshape dataset.
icm <- melt(icm, id = c("Date", "GE"), variable_name = "Party")
# Check result.
head(icm)



# Check party name order.
levels(icm$Party)



# View Set1 from ColorBrewer.
display.brewer.pal(7, "Set1")
# View selected color classes.
brewer.pal(7,"Set1")[c(2, 1, 5, 4)]



# ggplot2 manual color palette.
colors <- scale_colour_manual(values = brewer.pal(7,"Set1")[c(2, 1, 5, 4)])
# ggplot2 manual fill color palette.
fcolors <- scale_fill_manual(values = brewer.pal(7,"Set1")[c(2, 1, 5, 4)])
# ggplot2 option to set titles.
titles <- labs(title= "Guardian/ICM voting intentions polls\n",
               y = NULL, x = NULL)



# Time series lines.
qplot(data = icm, y = value, x = Date, color = Party, geom = "line") + 
  colors + titles



# Scatterplot.
qplot(data = icm, y = value, x = Date, 
      color = Party, size = I(.75), geom = "point") +
  geom_smooth(se = FALSE) + 
  colors + titles



# Stacked area plot.
qplot(data = icm, y = value, x = Date,
      color = Party, fill = Party, stat="identity", geom = "area") + 
  colors + fcolors + titles



# Stacked bar plot.
qplot(data = ddply(icm, .(Year = year(Date), Party), summarize, value = mean(value)), 
      fill = Party, color = Party, x = Year, y = value, 
      stat = "identity", geom = "bar") + 
  colors + fcolors + titles



# Plotting only general elections.
qplot(data = icm[icm$GE, ], y = value, x = Date, 
      color = Party, size = I(.75), geom = "line") +
  geom_point(size = 12, color = "white") +
  geom_text(aes(label = year(Date)), size = 4) +
  colors + titles


