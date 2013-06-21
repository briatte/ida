

# Load packages.
packages <- c("countrycode", "downloader", "foreign", "ggplot2", "maps", "RColorBrewer")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Get world map coordinates from the maps package.
w <- map_data("world", zoom = 4)
# Fix a few country names.
w$region[which(w$region == "USA")] = "United States"
w$region[which(w$region == "UK")] = "United Kingdom"
w$region[which(w$region == "USSR")] = "Russia"
w$region[which(w$region == "Zaire")] = "Congo, Democratic Republic"
w$region[which(w$region == "North Korea")] = "Korea, North"
w$region[which(w$region == "South Korea")] = "Korea, South"
# Remove Antarctica.
w <- subset(w, !region %in% c("Antarctica", "Greenland"))
# Download Quality of Government Standard dataset.
link = "http://www.qogdata.pol.gu.se/data/qog_std_cs.dta"
file = "data/qog.cs.dta"
data = "data/qog.cs.txt"
if(!file.exists(data)) {
  if(!file.exists(file)) download(link, file, mode = "wb")
  write.csv(read.dta(file), data)
}
# Read local copy.
qog <- read.csv(data, stringsAsFactors = FALSE)



qog.map <- function(x) {
  # Extract QOG variables.
  data <- with(qog, data.frame(
    country = gsub(" (\\(.*)", "", cname),
    variable = qog[, which(names(qog) == x)]))
  # Match QOG data to map.
  w$fill <- with(data, by(variable, country, mean))[w$region]
  set1 = brewer.pal(9, "Set1")
  # Plot over blank theme.
  p = qplot(data = w, x = long, y = lat,
            group = group, fill = fill, geom = "polygon")
  p = p + scale_fill_gradient2("",
                               low = set1[1], mid = set1[6], high = set1[3], 
                               midpoint = mean(w$fill, na.rm = TRUE),
                               na.value = set1[9])
  p = p + theme(axis.text = element_blank(),
                axis.ticks = element_blank(),
                panel.grid = element_blank())
  p = p + labs(y = NULL, x = NULL)
  return(p)  
}



# Plot a simple QOG map.
qog.map("ciri_empinx_new") + 
  labs(title = "CIRI Empowerment Rights Index (0-14) in 2009")



# Get Crayola colors from a personal copy.
source_url("https://raw.github.com/gist/5813759", prompt = FALSE)
# Plot with Crayola color gradient.
qog.map("wdi_the") + 
  labs(title = "Total health expenditure (% of GDP) in 2009") +
  scale_fill_gradient2("", 
                       low = crayola["Blue Green"], 
                       high = crayola["Sunset Orange"], 
                       mid = crayola["Yellow"], 
                       midpoint = mean(qog$wdi_the, na.rm = TRUE), 
                       na.value = crayola["Gray"])


