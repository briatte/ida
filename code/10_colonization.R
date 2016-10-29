#
# IDA: Exercise #3
#

#
# PACKAGES
#
packages <- c("car", "countrycode", "devtools", "downloader", "ggplot2", "reshape")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    # Install if needed.
    install.packages(x)
    library(x, character.only = TRUE)
  }
})

# Install the ggcorr function.
source_gist("5272298")

#
# DATA
#

# Download dataset.
data = "data/qog_cs.csv"
if(!file.exists(data)) {
  # Check for data folder.
  if(!file.exists("data")) dir.create("data")
  url = "http://www.qog.pol.gu.se/digitalAssets/1358/1358024_qog_csd_csv_v6apr11.csv"
  download(url, data, mode = "wb")
}

# Download codebook.
file = "data/qog_codebook.pdf"
url = "http://www.qogdata.pol.gu.se/codebook/codebook_standard_20110406.pdf"
if(!file.exists(file)) download(url, file, mode = "wb")

# Import data from CSV format.
qog_cs <- read.csv(data, sep = ";")

# Subset to variables of interest.
qog <- with(qog_cs, data.frame(
  ccode  = ccodealp,     # Country 3-letter code
  cname  = cname,        # Country name
  log_gdpc  = log(unna_gdp / unna_pop), # DV: Real GDP per capita (USD)
  malaria   = sa_mr,          # Malaria risk (% of population)
  net_aid   = wdi_aid / 10^9, # Net Official Development Assistance (USD bn)
  settler   = ajr_settmort,   # Log mortality rate of European settlers
  ethfrac   = al_ethnic,      # Ethnic fractionalization
  xcolony   = ht_colonial     # Colonial origin
))

# Code continental area (for reference only).
qog$region <- countrycode(qog$ccode, "iso3c", "continent")

# Code former Spanish, British and French colonies.
qog$xcolony <- factor(ifelse(qog$xcolony %in% c(2, 5, 6), qog$xcolony, NA))
levels(qog$xcolony) <- c("Spanish", "British", "French")

# Subset to fully measured observations.
qog <- na.omit(qog)

# Check regional and colonial composition of selected countries.
table(qog$xcolony, qog$region)

# Check overall data.
head(qog)

#
# DESCRIPTIVES
#

# Distribution of the dependent variable, by colonial origin.
qplot(data = qog, x = log_gdpc, geom = "density") + facet_grid(xcolony ~ .)

# Scatterplot matrix of continuous predictors (independent variables).
scatterplotMatrix(qog[, 3:7], smoother = FALSE)

# Correlation matrix.
ggcorr(qog[, 3:7])

# Simple regression line for log-GDP/capita by log-settler mortality.
g <- qplot(data = qog, y = log_gdpc, x = settler, geom = "point") + 
  geom_smooth(method = "lm")

# Show plot.
g

# Show by colonial origin.
g + aes(color = xcolony, fill = xcolony)

#
# MODELS
#

# Model 1: Baseline model.
m1 <- lm(log_gdpc ~ malaria + net_aid, data = qog)

# Summary of M1.
summary(m1)

# Model 2: M1 + ethnic fractionalization + log-settler mortality.
m2 <- lm(log_gdpc ~ malaria + net_aid + ethfrac + settler, data = qog)

# Summary of M2.
summary(m2)

# Separate the effect of settler mortality for each colonial origin.
qog$settlerSP <- ifelse(qog$xcolony=="Spanish", qog$settler, 0)
qog$settlerFR <- ifelse(qog$xcolony=="French",  qog$settler, 0)
qog$settlerUK <- ifelse(qog$xcolony=="British", qog$settler, 0)

# Model 3: M2 with log-settler mortality by colonial origin.
m3 <- lm(log_gdpc ~ malaria + net_aid + ethfrac + settlerSP + settlerFR + settlerUK, data = qog)

# Summary of M3.
summary(m3)

# Prepare a coefficients plot.
m3.summary <- data.frame(
  vars = names(coef(m3)),    # variable names
  coef = coef(m3),           # regression coefficients
  se   = sqrt(diag(vcov(m3)))) # standard error

# Remove constant from summary.
m3.summary <- m3.summary[-1, ]

# Show coefficients plot.
qplot(data = m3.summary, y = vars, x = coef, geom = "point") +
  geom_errorbarh(aes(xmin = coef - se, xmax = coef + se, height = .2)) +
  geom_vline(x = 0, linetype = "dotted") +
  labs(y = "Predictors", x = "Estimated effect ± 1 standard error")
