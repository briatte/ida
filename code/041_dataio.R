

# Load packages.
packages <- c("countrycode", "downloader", "foreign", "ggplot2", "plyr", "RCurl", "XML")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Create a filename for the dataset.
file = "data/dailykos.votes.0812.txt"
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
# Plot distribution of Obama vote share.
qplot(data = dkos, x = Obama.2012, 
      fill = Party, colour = Party, alpha = I(.75), geom = "density") +
  labs(y = "Density", x = "Obama vote share in 2012")



# Download Quality of Government Basic codebook.
file = "data/qog.codebook.pdf"
if(!file.exists(file)) {
  url = "http://www.qogdata.pol.gu.se/codebook/codebook_standard_20110406.pdf"
  download(url, file, mode = "wb")
}



# Download Quality of Government Standard dataset.
link = "http://www.qogdata.pol.gu.se/data/qog_std_cs.dta"
file = "data/qog.cs.dta"
data = "data/qog.cs.txt"
if(!file.exists(data)) {
  if(!file.exists(file)) download(link, file, mode = "wb")
  write.csv(read.dta(data), file)
}
# Read local copy.
qog <- read.csv(data, stringsAsFactors = FALSE)



# Add geographic continents using UN country codes.
qog$continent = factor(countrycode(qog$ccodealp, "iso3c", "continent"))
# Plot log-GDP/capita and female education, weighted by population (2002).
qplot(data = qog, y = log(wdi_gdpc), x = bl_asy25f, 
      colour = continent, size = mad_pop / 10^3, geom = "point") +
  scale_colour_brewer("Continent\n", palette = "Set1") +
  scale_size_area("Population\n", max_size = 24) + 
  labs(y = "log GDP/capita", x = "Female schooling years") +
  theme(legend.key = element_rect(colour = "white"))



files = "data/fide"
dir.create(files)



# Link to each table.
url = "http://ratings.fide.com/advaction.phtml?l?idcode=&name=&title=all_g&other_title=&country=&sex=&srating=0&erating=3000&birthday=&radio=name&ex_rated=&line=asc&inactiv=&offset="
# Link parameter.
i <- seq(0, 4900, 100)



data <- lapply(i, FUN = function(x) {
  # Define filename.
  file = paste0(files, "/fide.table.", x, ".txt")
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
    write.csv(data, file)
  } else {
    message("Skipping table #", x)
  }
})



# Extract tables to list.
data <- lapply(dir(files), FUN = function(x) {
	read.csv(paste0(files, "/", x))
})
# Convert list to data frame.
data <- rbind.fill(data)
# Remove rows with no player.
data <- data[!is.na(data$Name), ]
# Check result.
tail(data)



qplot(data = data, x = T, y = as.numeric(substr(Sys.Date(), 0, 4)) - B.Year,
	fill = S, alpha = I(.25), geom = "boxplot") +
	scale_fill_brewer("Sex\n", palette = "Set1") +
	labs(x = "FIDE title", y = "Age")


