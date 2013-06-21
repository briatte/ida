

# Load packages.
packages <- c("countrycode", "ggplot2", "reshape", "WDI")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Target file.
file = "data/wdi.births.2005.txt"
# Download source.
if(!file.exists(file)) {
  message("Downloading the data...")
  # Using the WDI package.
  wdi <- WDI(indicator = c("SP.DYN.TFRT.IN", "NY.GDP.PCAP.CD"), start = 2005, end = 2005)
  # Save local copy.
  write.csv(wdi, file, row.names = FALSE)
}
# Load CSV file.
wdi <- read.csv(file)
# Check result.
str(wdi)



wdi$iso3c <- countrycode(wdi$iso2c, "iso2c", "iso3c")
wdi$Continent <- countrycode(wdi$iso2c, "iso2c", "continent")
wdi <- na.omit(wdi)



# Scatterplot of fertility and GDP per capita with country codes and continents.
qplot(data = wdi, y = SP.DYN.TFRT.IN, x = log(NY.GDP.PCAP.CD), 
      color = Continent, label = iso3c, size = I(4), geom = "text") +
  labs(y = "Fertility rate", x = "GDP per capita (log units)")



# Box plot of fertility rate by continent.
qplot(data = wdi,
      y = SP.DYN.TFRT.IN, x = reorder(Continent, SP.DYN.TFRT.IN, median), 
      color = Continent, geom = "boxplot") +
  labs(y = "Fertility rate", x = NULL) +
  theme(legend.position = "none")


