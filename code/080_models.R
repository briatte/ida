

# Load packages.
packages <- c("downloader", "ggplot2")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Identify the data file.
file = "data/olympics.2012.csv"
# Identify the data source.
link = "https://raw.github.com/briatte/ida/master/data/olympics.2012.csv"
# Download the data if needed.
if(!file.exists(file)) download(link, file, mode = "wb")
# Read the data.
olympics <- read.table(file, stringsAsFactors = FALSE)
# Check result.
head(olympics)



# Scatterplot of sprinter results.
g <- qplot(data = olympics, y = Result, x = Year)
# Show plot with LOESS curve.
g + geom_smooth()



# Compute the sprint result as a function of its year, excluding 1896.
olympics.linear <- lm(Result ~ Year, data = olympics[-1, ])
# Show the result.
olympics.linear
# Plot the result.
g + geom_abline(intercept = coef(olympics.linear)[1], slope = coef(olympics.linear)[2])



# Model the natural logarithm of the sprint result.
olympics.log.linear <- lm(log(Result) ~ Year, data = olympics[-1, ])
# Create the sequence of years for which to predict the result.
predicted.years <- data.frame(Year = seq(1900, 2012, 4))
# Predict the result for years 1900-2012.
predicted.times <- data.frame(Year = predicted.years,
                           exp(predict(olympics.log.linear, 
                           newdata = predicted.years, 
                           level = 0.95,
                           interval = "prediction")))
# Merge predictions to the original data.
olympics <- merge(olympics, predicted.times, by = "Year", all = TRUE)
# Check result, excluding a few columns.
tail(olympics)[-c(2, 4)]



# Plot the model.
qplot(data = olympics, x = Year, y = Result) + 
  geom_point(x = 2012, y = olympics$fit[31], color = "yellow", size = 10) +
  geom_point(y = olympics$fit, color = "red") +
  geom_line(y = olympics$upr, color = "red", linetype = "dashed") +
  geom_line(y = olympics$lwr, color = "red", linetype = "dashed")



# Model the full data.
olympics.log.linear.full <- lm(log(Result) ~ Year, data = olympics)
# Predict the result for year 2012.
data.frame(Year = predicted.years,
                          exp(predict(olympics.log.linear.full, 
                           newdata = predicted.years, 
                           level = 0.95,
                           interval = "prediction")))[29, ]


