if(!file.exists("data/qog_basic_ts.csv")) {
  if(!file.exists("data")) {
    dir.create("data")
  }
  if(!require(RCurl)) {
    install.packages("RCurl")
    library(RCurl)
  }
  url <- "http://www.qog.pol.gu.se/digitalAssets/1373/1373433_qog_basic_ts_csv_120608.csv"
  qog <- getURL(url)
  qog <- read.csv(textConnection(qog))
  write.csv(qog, file = "data/qog_basic_ts.csv")
} else {
  # Open local copy.
  qog <- read.csv("data/qog_basic_ts.csv")
}
