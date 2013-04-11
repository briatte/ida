

# Load packages.
packages <- c("downloader", "ggplot2", "reshape", "scales", "xlsx", "zoo")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Target data link.
link = "http://elsa.berkeley.edu/~saez/TabFig2011prel.xls"
# Target data file.
file = "data/piketty-saez-2011.xls"
# Download dataset.
if (!file.exists(file)) {
  message("Dowloading the data...")
  # Download spreadsheet.
  download(link, file)
}



# Import from XLS format.
ps_share <- read.xlsx(file, sheetName = "Table A1", 
                      rowIndex = c(4, 6:104), colIndex = 1:7)
# Check result.
str(ps_share)
# Change variable names.
names(ps_share) <- c("Year", "Top 10%", "Top 5%", "Top 1%", "Top 0.5%", "Top 0.1%", "Top 0.01%")
# Reshape to long format.
ps_share <- melt(ps_share, id = "Year", variable_name = "Fractile")
# Drop missing data.
ps_share <- na.omit(ps_share)
# Check result.
head(ps_share)



# Time series plot.
qplot(data = ps_share, x = Year, y = value, color = Fractile, geom = "line") + 
  labs(y = NULL, x = NULL, title = "U.S. top income shares (%)\n")



# Import from XLS format.
ps_income <- read.xlsx(file, sheetName = "Table_Incomegrowth", 
                       rowIndex = c(2, 5:103), colIndex = c(10, 5, 3))
# Add years manually.
ps_income <- cbind(1913:2011, ps_income)
# Check result.
str(ps_income)
# Change variable names.
names(ps_income) <- c("Year", "Top 10%", "Top 1%", "Bottom 90%")
# Reshape to long format.
ps_income <- melt(ps_income, id = "Year", variable_name = "Fractile")
# Drop missing data.
ps_income <- na.omit(ps_income)
# Check result.
head(ps_income)



# Plot in real dollar units.
qplot(data = ps_income, x = Year, y = value, color = Fractile, geom = "line") +
  labs(y = NULL, x = NULL, title = "Real income growth in the United States\n") +
  scale_y_continuous(labels = dollar)



# Plot in log10 dollar units.
qplot(data = ps_income, x = Year, y = value, color = Fractile, geom = "line") +
  labs(y = NULL, x = NULL, title = "Real income growth in the United States\n") +
  scale_y_log10(labels = dollar)



# Create year data.
df <- data.frame(t = 2001:2005, x = (1:5)^2)
# Check result.
str(df)
# Create zoo object.
df <- with(df, zoo(x, t))
# Check result.
str(df)
# Extract core data.
coredata(df)
# Extract time index.
index(df)



# Original time series.
df
# Lagged at k = -2: shifts series right by two years.
lag(df, -2, na = TRUE)
# Lagged at k = -1: shifts series right by one year.
lag(df, -1, na = TRUE)
# Lagged at k = +1: shifts series left by one year.
lag(df, 1, na = TRUE)
# Lagged at k = +2: shifts series left by two years.
lag(df, 2, na = TRUE)



# Recall the time series and lagged values.
t(cbind(df, lag(df, -1)))
# Compute the successive differences.
diff(df)
# Show differences with both time series.
t(cbind(df, lag(df, -1), diff(df)))



# Add lagged series.
ps_income <- ddply(ps_income, .(Fractile), transform,
                   lagged = c(NA, value[-length(value)]))
# Create growth rate.
ps_income$rate <- with(ps_income, (value / lagged) - 1)
# Plot real income growth rates.
qplot(data = ps_income, 
      ymin = 0, ymax = rate, x = Year, geom = "linerange") +
  geom_hline(y = 0, color = "gray") +
  aes(color = ifelse(rate > 0, "positive", "negative")) +
  scale_colour_manual("", values = c("positive" = "blue", "negative" = "red")) +
  scale_y_continuous(labels = percent) +
  facet_grid(Fractile ~ .)



# Add differenced series.
ps_income <- ddply(ps_income, .(Fractile), transform,
                   Difference = c(NA, diff(value)))
# Plot real income percentage changes.
qplot(data = ps_income, 
      ymin = 0, ymax = Difference, x = Year, geom = "linerange") +
  geom_hline(y = 0, color = "gray") +
  aes(color = ifelse(rate > 0, "positive", "negative")) +
  scale_colour_manual("", values = c("positive" = "blue", "negative" = "red")) +
  scale_y_continuous(labels = dollar) +
  facet_grid(Fractile ~ ., scale = "free_y")



# Subsetting to top 1% incomes.
ps_top1 <- subset(ps_income, Fractile=="Top 1%")
# Create a time series.
ps_top1 <- with(ps_top1, zoo(value, Year))
# Check result.
str(ps_top1)
# Detrend the series.
m <- lm(coredata(ps_top1) ~ index(ps_top1))
# Plot the residuals.
qplot(ymin = 0, ymax = resid(m), x = index(ps_top1), geom = "linerange") +
  aes(color = ifelse(resid(m) > 0, "positive", "negative")) +
  scale_color_manual("Residuals\n", 
                     values = c("positive" = "red", "negative" = "blue")) +
  scale_y_continuous(label = dollar) +
  labs(x = NULL, title = "Detrended series of top 1% income growth\n")


