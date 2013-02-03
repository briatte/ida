

# Load RCurl package.
library(RCurl)
# Store the address of the spreadsheet.
dk.link <- "https://docs.google.com/spreadsheet/pub?key=0Av8O-dN2giY6dEFCOFZ4ZnlKS0x3M3Y0WHd5aWFDWkE&output=csv"



if (!file.exists("data/dailykos.csv")) {
  # Download spreadsheet.
  dk.html <- getURL(dk.link, ssl.verifypeer = FALSE)
  # Convert result to proper dataset, leaving strings as such.
  dk.data <- read.csv(textConnection(dk.html), stringsAsFactors = FALSE)
  # Save local copy.
  write.csv(dk.data, file = "data/dailykos.csv")
} else {
  # Open local copy.
  dk.data <- read.csv("data/dailykos.csv")
}



# Have a look at the final result.
str(dk.data)
# List the first data rows.
head(dk.data)



if(!file.exists("data/qog_basic_cs.csv")) {
  if(!file.exists("data")) {
   dir.create("data")
  }
  if(!require(RCurl)) {
    install.packages("RCurl")
    library(RCurl)
  }
  url <- "http://www.qog.pol.gu.se/digitalAssets/1373/1373417_qog_basic_cs_csv_120608.csv"
  qog <- getURL(url)
  qog <- textConnection(qog)
  qog <- read.csv(qog)
  write.csv(qog, file = "data/qog_basic_cs.csv")
}



# Load the package.
library(xlsx)
# Import the data.
if (file.exists("data/us_inflation.xlsx")) {
  # Open local copy.
  infl <- read.xlsx("data/us_inflation.xlsx","median_income", header = FALSE)
} else {
  print("Cannot find dataset, loading from web...")
  # Retrieve file.
  infl <- read.xlsx("http://www.inflationtrends.com/data/Raw_data.xlsx", header = FALSE)
  # Save local copy.
  write.xlsx(infl, file = "data/us_inflation.xlsx")
}
# Check the result.
str(infl)
# Subset to columns 3 to 4.
infl <- infl[3:4]
# Add column names.
names(infl) <- c("year","medinc")



# A quick plot.
qplot(year, medinc, data = infl, geom = "line")



# Check how far the series goes.
summary(infl$year)
# Plot the last twenty years.
qplot(year,medinc,data=subset(infl, year > 1992),geom="line")



# A quick plot with a log scale.
qplot(year,medinc,data=infl,geom="line",log="y")


