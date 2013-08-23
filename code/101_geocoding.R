

packages <- c("downloader", "ggmap", "plyr")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Get the data.
url = "http://aiddata.org/weceem_uploads/_ROOT/File/geocoding/AllWorldBank_IBRDIDA.zip"
zip = "data/wb.projects.zip"
if(!file.exists(zip)) download(url, zip, mode = "wb")
# Read from the ZIP file.
wb = read.csv(unz(zip, "AllWorldBank_IBRDIDA.csv"))
# Subset to Africa.
wb = subset(wb, Region == "AFRICA")
# Inspect variables.
v = c("Project.ID", "Latitude", "Longitude", "Country", "Total.Amt")
head(wb)[v]



# Get OpenStreetMap data.
map =  get_map(location = 'Africa', zoom = 4, source = "osm")
# Plot World Bank projects.
ggmap(map) + 
  geom_point(data = wb, 
             aes(x = Longitude, y = Latitude, color = Country, size = Total.Amt),
             alpha = .3) + 
  scale_size_area(max_size = 8) + 
  labs(y = NULL, x = NULL) +
  theme(axis.text = element_blank(), 
        axis.ticks = element_blank(),
        legend.position = "none")



# Get OpenStreetMap data.
ton = get_map(location = 'Africa', zoom = 4, source = "stamen", maptype = "watercolor")
# Plot World Bank projects.
ggmap(ton) + 
  geom_point(data = wb, 
             aes(x = Longitude, y = Latitude, color = Country, size = Total.Amt)) + 
  scale_size_area(max_size = 8) +
  labs(y = NULL, x = NULL) +
  theme(axis.text = element_blank(), 
        axis.ticks = element_blank(),
        legend.position = "none")


