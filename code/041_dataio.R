

# Load RCurl package.
require(RCurl)
# Store the address of the spreadsheet.
link = "https://docs.google.com/spreadsheet/pub?key=0Av8O-dN2giY6dEFCOFZ4ZnlKS0x3M3Y0WHd5aWFDWkE&output=csv"
# Create a filename for the dataset.
file = "data/dkos-us0812.txt"



# Download dataset.
if (!file.exists(file)) {
  message("Dowloading the data...")
  # Download and read HTML spreadsheet.
  html <- textConnection(getURL(link, ssl.verifypeer = FALSE))
  # Convert and export CSV spreadsheet.
  write.csv(read.csv(html), file)
}
# Open file.
dkos <- read.csv(file, stringsAsFactors = FALSE)
# Check result.
str(dkos)



# Have a look at the final result.
str(dkos)
# List the first data rows.
head(dkos)



require(downloader)
# Download Quality of Government Basic codebook.
file = "data/qog-basic-codebook.pdf"
if(!file.exists(file)) {
  url = "http://www.qogdata.pol.gu.se/codebook/codebook_basic_20120608.pdf"
  download(url, file, mode = "wb")
}
# Download Quality of Government Basic dataset.
file = "data/qog-basic-cs.csv"
if(!file.exists(file)) {
  url = "http://www.qog.pol.gu.se/digitalAssets/1373/1373417_qog_basic_cs_csv_120608.csv"
  download(url, file, mode = "wb")
}
# Open local copy.
qog <- read.csv(file)



# Load the xlsx package.
require(xlsx)
# Set target file.
file = "data/us_inflation.xlsx"
# Import the data.
if (!file.exists(file)) {
  url = "http://www.inflationtrends.com/data/Raw_data.xlsx"
  download(url, file, mode = "wb")
}
# Open local copy.
infl <- read.xlsx(file, "median_income", header = FALSE)
# Check the result.
str(infl)
# Subset to columns 3 to 4.
infl <- infl[3:4]
# Add column names.
names(infl) <- c("year", "medinc")



# A quick plot.
qplot(year, medinc, data = infl, geom = "smooth")



# Check how far the series goes.
summary(infl$year)
# Plot the last twenty years.
qplot(year, medinc, data = subset(infl, year > 1992), geom = "smooth")



# A quick plot with a log scale.
qplot(year, medinc, data = infl, geom = "smooth", log = "y")


