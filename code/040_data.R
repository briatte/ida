

# Load packages.
packages <- c("ggplot2", "WDI")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Get WDI data.
wdi <- WDI(country = c("US", "GB", "DE","FR", "GR"), 
           indicator = "GC.DOD.TOTL.GD.ZS", start = 2005, end = 2011, 
           extra = TRUE, cache = NULL)
# Check result.
str(wdi, vec.len = 1)



# Smoothed time series plot.
g = qplot(data = wdi, x = year, y = GC.DOD.TOTL.GD.ZS,
      colour = country, se = FALSE, geom = c("smooth", "point")) +
  scale_colour_brewer("Country", palette = "Set1") +
  labs(title = "Central government debt, total (% GDP)\n", y = NULL, x = NULL)
# View result.
g



g + geom_text(data = subset(wdi, year == 2011), 
            aes(x = 2011.25, y = GC.DOD.TOTL.GD.ZS, label = country), hjust = 0) +
  scale_x_continuous(lim = c(2005, 2012.5)) +
  theme(legend.position = "none", panel.grid.minor = element_blank())



# Target file location.
file = "data/wdi.govdebt.0511.txt"
# Export CSV file.
write.csv(wdi, file)
# Read CSV file again.
wdi <- read.csv(file)


