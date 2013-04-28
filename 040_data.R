
## @knitr packages, message=FALSE, warning=FALSE
# Load packages.
packages <- c("ggplot2", "WDI")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})


## @knitr WDI-data
# Get WDI data.
wdi <- WDI(country = c("US", "GB", "DE","FR", "GR"), 
           indicator = "GC.DOD.TOTL.GD.ZS", start = 2005, end = 2012, 
           extra = TRUE, cache = NULL)
# Check result.
str(wdi, vec.len = 1)


## @knitr WDI-plot, tidy=FALSE, message=FALSE, warning=FALSE
qplot(data = wdi, x = year, y = GC.DOD.TOTL.GD.ZS,
      colour = country, se = FALSE, geom = c("smooth", "point")) +
  geom_text(data = subset(wdi, year == 2011), 
            aes(x = 2011, y = GC.DOD.TOTL.GD.ZS, label = iso2c), hjust = -.5) +
  scale_x_continuous(breaks = 2005 + 2 * 0:4) +
  scale_colour_brewer("", palette = "Set1") +
  labs(title = "Central government debt, total (% of GDP)\n",
       y = NULL, x = NULL)


