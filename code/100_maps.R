

library(maps)
library(ggplot2)
eu <- map_data("world")
qog <- read.csv("data/qog_cs.csv", sep = ";", stringsAsFactors = FALSE)
qog <- with(qog, data.frame(
  region = cname,
  fertility = wdi_fr, stringsAsFactors = FALSE))
eu <- merge(eu, qog, all.x = TRUE, by.x = "region", by.y = "region")
# qplot(data = eu, x = long, y = lat, geom = "polygon", fill = fertility)


