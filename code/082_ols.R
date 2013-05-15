

# Load packages.
require(downloader)
require(foreign)
dataset = "data/Hibbs.2012.txt"
# Download the data.
if(!file.exists(dataset)) {
  file = "data/Hibbs.2012.dta"
  if(!file.exists(file))
    download("http://www.douglas-hibbs.com/HibbsArticles/HIBBS-OBAMA-FORECAST-27July2012-WEBPOST.dta", file)
  hibbs <- read.dta(file)
  write.table(hibbs, dataset, sep = ",")
}
# Load the data.
hibbs <- read.csv(dataset, stringsAsFactors = FALSE)
# Subset to election quarters.
hibbs <- subset(hibbs, !is.na(presvote))



source("code/vwreg.r")



# Import the data.
if (file.exists("data/qog_basic_cs.csv")) {
  # Open local copy.
  qog <- read.csv("data/qog_basic_cs.csv")
} else {
  print("Cannot find dataset, loading from web...")
  # Retrieve file.
  qog <- read.csv("http://www.qog.pol.gu.se/digitalAssets/1373/1373417_qog_basic_cs_csv_120608.csv", header = FALSE)
  # Save local copy.
  write.csv(qog, file = "data/qog_basic_cs.csv")
}

p1 <- vwReg(wdi_fr ~ bl_asyf25 + I(bl_asyf25^2), qog, method=lm)

p1 + ylab("Fertility rate") + xlab("Average education years among 25+ year-old females")


