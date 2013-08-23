

# Load packages.
packages <- c("countrycode", "downloader", "foreign", "ggplot2", "plyr", "RCurl", "XML")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Create a filename for the dataset.
file = "data/dailykos.votes.0812.csv"
# Store the address of the spreadsheet.
link = "https://docs.google.com/spreadsheet/pub?key=0Av8O-dN2giY6dEFCOFZ4ZnlKS0x3M3Y0WHd5aWFDWkE&output=csv"



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



# List first data rows.
head(dkos)
# Plot data points with regression line and density curves.
qplot(data = dkos, y = Obama.2012, x = Obama.2008, 
      colour = Party, size = I(2), geom = "point") + 
  geom_abline(alpha = .5) + 
  geom_density2d() +
  scale_x_continuous(lim = c(0, 100)) + 
  scale_y_continuous(lim = c(0, 100))



# Target locations.
link = "http://www.qogdata.pol.gu.se/data/Codebook_QoG_Std15May13.pdf"
file = "data/qog.codebook.pdf"
# Download Quality of Government Standard codebook.
if(!file.exists(file)) download(link, file, mode = "wb")



# Extract Quality of Government Standard cross-sectional data from a ZIP archive.
zip = "data/qog.cs.zip"
qog = "data/qog.cs.csv"
if(!file.exists(zip)) {
  dta = "data/qog.cs.dta"
  download("http://www.qogdata.pol.gu.se/data/qog_std_cs.dta", dta, mode = "wb")
  write.csv(read.dta(dta, warn.missing.labels = FALSE), qog)
  zip(zip, file = c(dta, qog))
  file.remove(dta, qog)
}
qog = read.csv(unz(zip, qog), stringsAsFactors = FALSE)



# Add geographic continents using UN country codes.
qog$continent = factor(countrycode(qog$ccodealp, "iso3c", "continent"))
# Plot log-GDP/capita and female education, weighted by population (2002).
qplot(data = qog, y = log(wdi_gdpc), x = bl_asy25f, 
      colour = continent, size = mad_pop / 10^3, geom = "point") +
  scale_colour_brewer("Continent\n", palette = "Set1") +
  scale_size_area("Population\n", max_size = 24) + 
  labs(y = "log GDP/capita", x = "Female schooling years")



files = "data/fide"
if(!file.exists(files)) dir.create(files)



# Link to each table.
url = "http://ratings.fide.com/advaction.phtml?title=g&offset="
# Link parameter.
i <- seq(0, 1400, 100)



# Scraper function.
fide <- sapply(i, FUN = function(x) {
  # Define filename.
  file = paste0(files, "/fide.table.", x, ".csv")
  # Scrape if needed.
  if(!file.exists(file)) {
    message("Downloading data to ", file)
    # Parse HTML.
    html <- htmlParse(paste0(url, x))
    # Select second table.
    html <- xpathApply(html, "//table[@class='contentpaneopen']")[[2]]
    # Import table.
    data <- readHTMLTable(html, skip.rows = 1:3, header = TRUE)[, -1]
    # Save as CSV.
    write.csv(data, file, row.names = FALSE)
  } else {
    message("Skipping table #", x)
  }
  return(file)
})
# Zip archive.
zip("data/fide.zip", fide)
# Delete workfiles.
message(fide)
message(files)
file.remove(fide, files)



# Import tables into a list.
fide <- lapply(fide, function(x) {
  read.csv(unz("data/fide.zip", x))
})
# Convert list to data frame.
fide <- rbind.fill(fide)
# Remove rows with no player.
fide <- fide[!is.na(fide$Name), ]
# Check result.
tail(fide)



# Determine birth cohort (decades).
fide$cohort <- cut(fide$B.Year, 
              breaks = seq(1919, 1999, 10), 
              labels = seq(1920, 1999, 10))
# Plot ratings over age and sex.
qplot(data = subset(fide, !is.na(cohort)), 
      x = cohort, y = Rtg, fill = S, alpha = I(.5),
      geom = "boxplot") +
	scale_fill_brewer("Sex\n", palette = "Set1") +
	labs(x = "Birth cohort", y = "FIDE standard rating")


