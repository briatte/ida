

# Load packages.
packages <- c("countrycode", "ggplot2", "reshape", "WDI")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



file = "data/WDI.extract.txt"
if(!file.exists(file)) {
  message("Dowloading the data...")
  wdi <- WDI(indicator = c("SP.DYN.TFRT.IN", "NY.GDP.PCAP.CD"), start = 2005, end = 2005)
  write.table(wdi, file)
} else {
 wdi <- read.csv(file)
}

str(wdi)



wdi$iso3c <- countrycode(wdi$iso2c, "iso2c", "iso3c")
wdi$Continent <- countrycode(wdi$iso2c, "iso2c", "continent")
wdi <- na.omit(wdi)



# Scatterplot of fertility and GDP per capita with country codes and continents.
qplot(data = wdi, y = SP.DYN.TFRT.IN, x = log(NY.GDP.PCAP.CD), 
      color = Continent, label = iso3c, size = I(4), geom = "text") +
  labs(y = "Fertility rate", x = "GDP per capita (log units)")



# Box plot of fertility rate by continent.
qplot(data = wdi, y = SP.DYN.TFRT.IN, x = Continent, 
      color = Continent, geom = "boxplot") +
    labs(y = "Fertility rate", x = "")


