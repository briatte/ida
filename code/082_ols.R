

# Load packages.
require(downloader)
require(foreign)
data = "data/hibbs.2012.txt"
# Download the data.
if(!file.exists(data)) {
  file = "data/hibbs.2012.dta"
	url = "http://www.douglas-hibbs.com/HibbsArticles/HIBBS-OBAMA-FORECAST-27July2012-WEBPOST.dta"
  if(!file.exists(file)) download(url, file, mode = "wb")
  write.csv(read.dta(file), data)
}
# Load the data.
hibbs <- read.csv(data, stringsAsFactors = FALSE)
# Subset to election quarters.
hibbs <- subset(hibbs, !is.na(presvote))



source("code/vwreg.r")



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

p1 <- vwReg(wdi_fr ~ bl_asyf25 + I(bl_asyf25^2), qog, method=lm)

p1 + ylab("Fertility rate") + xlab("Average education years among 25+ year-old females")


