

library(foreign)
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


