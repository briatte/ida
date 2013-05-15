

# Load packages.
packages <- c("countrycode", "downloader", "foreign", "ggplot2", "RCurl", "XML")
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
      fill = Party, colour = Party, alpha = I(.75), geom = "density")



# Download Quality of Government Basic codebook.
file = "data/qog.codebook.pdf"
if(!file.exists(file)) {
  url = "http://www.qogdata.pol.gu.se/codebook/codebook_standard_20110406.pdf"
  download(url, file, mode = "wb")
}



# Download Quality of Government Standard dataset.
file = "data/qog.cs.txt"
if(!file.exists(file)) {
  dta = "data/qog.cs.dta"
  if(!file.exists(dta)) {
    url = "http://www.qogdata.pol.gu.se/data/qog_std_cs.dta"
    download(url, dta, mode = "wb")
  }
  write.csv(read.dta(dta), file)
}
# Open local copy.
qog <- read.csv(file, stringsAsFactors = FALSE, header = TRUE)



# Add geographic continents using UN country codes.
qog$continent = factor(countrycode(qog$ccodealp, "iso3c", "continent"))
# Plot log-GDP/capita and female education, weighted by population (2002).
qplot(data = qog, y = log(wdi_gdpc), x = bl_asy25f, 
      colour = continent, size = mad_pop / 10^3, geom = "point") +
  scale_colour_brewer("Continent\n", palette = "Set1") +
  scale_size_area("Population\n", max_size = 24) + 
  labs(y = "log GDP/capita", x = "Female schooling years")



# Target data source.
file = "data/beijing.aqi.2013.txt"
if(!file.exists(file)) download("", file)
# Read. CSV file.
bp <- read.csv(file, stringsAsFactors = FALSE)
# Check result.
head(bp)
bp$time = strptime(bp$time, format = "%Y-%m-%d %T")
ggplot(data = bp, aes(x = time, y = PM)) +
  geom_line(color = "gray80") +
  geom_point(color = "blue", alpha = .5) +
  geom_smooth(fill = "lightblue") +
  labs(x = NULL, y = "Fine particles (PM2.5) 24hr avg")



html <- htmlParse("http://en.wikipedia.org/wiki/Arab_Spring")
html <- xpathApply(html, "//table/tr/th[contains(text(), 'Death toll')]/../..")[[1]]
data <- readHTMLTable(html)
str(data)
data$outcome <- as.numeric(data$Situation)
data$outcome <- cut(data$outcome, 
                    breaks = c(1, 2, 5, 7), include.lowest = TRUE, 
                    labels = c("Protests", "Concessions", "Revolt"))



# Assign country codes.
data$ccodealp <- countrycode(data[, 1], "country.name", "iso3c")
# Store unique regions.
continents <- countrycode(data$ccodealp, "iso3c", "continent")



# Download Quality of Government Standard dataset (time series).
file = "data/qog.ts.txt"
if(!file.exists(file)) {
  dta = "data/qog.ts.dta"
  if(!file.exists(dta)) {
    url = "http://www.qogdata.pol.gu.se/data/qog_std_ts.dta"
    download(url, dta, mode = "wb")
  }
  write.csv(read.dta(dta), file)
}
# Open local copy.
qog <- read.csv(file, stringsAsFactors = FALSE, header = TRUE)
# Merge and keep unmatched QOG countries.
data <- merge(data, qog, by = "ccodealp", all.y = TRUE)
# Add continents.
data$continent <- countrycode(data$ccodealp, "iso3c", "continent")



data <- subset(data, continent %in% unique(continents)[-3])
ggplot(data = data[data$year > 1960, ], aes(x = year, y = wdi_fr, group = ccodealp)) +
  geom_smooth(data = subset(data, is.na(outcome)), fill = "grey90", colour = "grey90", size = 2) +
  geom_smooth(data = subset(data, !is.na(outcome)), aes(fill = outcome, colour = outcome), size = 2) +
  scale_fill_manual(values = c("Protests" = "yellow", "Concessions" = "orange", "Revolt" = "Red")) +
  scale_colour_manual(values = c("Protests" = "yellow", "Concessions" = "orange", "Revolt" = "Red")) +
  facet_wrap(~ continent, nrow = 2)


