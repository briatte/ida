

# Load packages.
packages <- c("downloader", "ggplot2", "MASS", "reshape", "splines")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Target data source.
link = "https://raw.github.com/briatte/ida/master/data/beijing.aqi.2013.txt"
file = "data/beijing.aqi.2013.txt"
if(!file.exists(file)) download(link, file)
# Read CSV file.
bp <- read.csv(file, stringsAsFactors = FALSE)
# Check result.
head(bp)
# Convert date.
bp$time <- strptime(bp$time, format = "%Y-%m-%d %T")
# Plot air pollution.
ggplot(data = bp, aes(x = time, y = PM)) +
  geom_line(color = "gray80") +
  geom_point(color = "blue", alpha = .5) +
  geom_smooth(fill = "lightblue") +
  labs(x = NULL, y = "Fine particles (PM2.5) 24hr avg")



# Plot cubic spline with 2-length knots.
ggplot(data = bp, aes(x = time, y = PM)) +
  geom_line(color = "gray80") +
  geom_point(color = "blue", alpha = .5) +
  geom_smooth(method ="rlm", formula = y ~ ns(x, 12), alpha = .25, fill = "lightblue") +
  labs(x = NULL, y = "Fine particles (PM2.5) 24hr avg")



# Plot a differenced time series.
qplot(x = bp$time[-1], 
      y = diff(bp$PM), 
      geom = "line") + 
  labs(x = "t")



# Set vector of lagged values.
d = 1:9
# Create lags for one to eight days.
lags = sapply(d, FUN = function(i) { c(bp$PM[-1:-i], rep(NA, i)) } )
# Divide lagged values by series.
lags = lags / bp$PM
# Create lags dataset.
lags = data.frame(bp$time, lags)
# Fix variables names.
names(lags) = c("t", d)
# Melt data over days.
lags = melt(lags, id = "t", variable = "lag")
# Plot lagged dataset.
qplot(data = lags,
      x = t,
      y = value,
      colour = lag,
      geom = "line") + 
  labs(x = "t") + 
  scale_colour_brewer() + 
  theme(legend.position = "none")



# Correlogram function.
gglag <- function(x, method = "acf") {
  data = do.call(method, list(x, plot = FALSE))
  qplot(y = 0,
        yend  = data$acf,
        size  = data$acf,
        color = data$acf,
        x     = data$lag,
        xend  = data$lag,
        geom  = "segment") +
  scale_y_continuous("", lim = c(ifelse(method == "acf", 0, -1), 1)) +
  scale_size(toupper(method)) +
  scale_color_gradient2("",
                        low = "blue", 
                        mid = "white", 
                        high = "red", 
                        midpoint = 0) +
  labs(x = "Number of lags")
}



# Plot autocorrelation function.
gglag(bp$PM, "acf")
# Plot partial autocorrelation function.
gglag(bp$PM, "pacf")


