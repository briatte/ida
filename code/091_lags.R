

# Target data source.
link = "https://raw.github.com/briatte/ida/master/data/beijing.aqi.2013.txt"
file = "data/beijing.aqi.2013.txt"
if(!file.exists(file)) download("", file)
# Read CSV file.
bp <- read.csv(file, stringsAsFactors = FALSE)
# Check result.
head(bp)
bp$time <- strptime(bp$time, format = "%Y-%m-%d %T")
ggplot(data = bp, aes(x = time, y = PM)) +
  geom_line(color = "gray80") +
  geom_point(color = "blue", alpha = .5) +
  geom_smooth(fill = "lightblue") +
  labs(x = NULL, y = "Fine particles (PM2.5) 24hr avg")



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


