

# Load packages.
packages <- c("downloader", "foreign", "ggplot2", "RColorBrewer", "reshape")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Target locations.
link = "https://raw.github.com/briatte/ida/master/data/bartels.presvote.4812.csv"
file = "data/bartels.presvote.4812.csv"
# Download the data.
if(!file.exists(file)) download(link, file, mode = "wb")
# Load the data.
bartels <- read.csv(file, stringsAsFactors = FALSE)



# Scatterplot.
ggplot(bartels, aes(inc1415, incm, label = year)) +
  geom_smooth(method = "lm") +
  geom_text()
# Simple OLS.
m1 = lm(incm ~ inc1415, data = bartels)
# Results.
summary(m1)



m2 = lm(incm ~ inc1415 + I(tenure), data = bartels)
summary(m2)



# Extract model results.
m = rbind.fill(lapply(list(m1, m2), function(x) {
  model = as.character(x$call)[2]
  data.frame(model, 
             year = bartels$year,
             residuals = residuals(x), 
             yhat = fitted.values(x))
  }))
# Histogram of the residuals.
qplot(data = m, x = residuals, color = model, geom = "density") +
  scale_color_brewer("Models:", type = "qual", palette = "Set1") +
  theme(legend.position = "top")



# Get vwReg function.
source("code/8_vwreg.r")
# Get color palette.
palette = brewer.pal(9, "RdYlGn")
# Code plot builder.
ggfit <- function(x) {
  bartels$yhat = fitted.values(x)
  g = vwReg(incm ~ yhat, bartels, method = lm, palette = palette) + 
    geom_text(label = bartels$year)
  g + labs(y = "Incumbent Party Margin")
}
# Bootstrapped fitted values.
g1 = ggfit(m1)
g2 = ggfit(m2)



# Plot incumbent margin v. income growth.
g1 + labs(x = "Income Growth")
# Plot incumbent margin v. income growth, with tenure adjustment.
g2 + labs(x = "Income Growth, tenure-adjusted")



# Download Quality of Government Standard dataset.
link = "http://www.qogdata.pol.gu.se/data/qog_std_cs.dta"
file = "data/qog.cs.dta"
data = "data/qog.cs.csv"
if(!file.exists(data)) {
  if(!file.exists(file)) download(link, file, mode = "wb")
  write.csv(read.dta(file), data)
}
# Read local copy.
qog <- read.csv(data, stringsAsFactors = FALSE)
qog = na.omit(with(qog, data.frame(ccodealp, wdi_fr, bl_asy25f)))
# Regression models.
m1 = lm(wdi_fr ~ bl_asy25f, qog)
m2 = lm(wdi_fr ~ bl_asy25f + I(bl_asy25f^2), qog)
# ANOVA fit test.
anova(m1, m2)



# Code plot builder.
ggfit = function(x, ...) {
  vwReg(formula(x), data = qog, method = lm, spag = TRUE, shade = FALSE,
        slices = 50, ...)
  }
# Visually weighted regression of linear model, without and with quadratic term.
p1 = ggfit(m1, spag.color = palette[1])
p2 = ggfit(m2, spag.color = palette[9], add = TRUE)



# Construct plot for the regression results.
p1 + p2 + geom_point() +
  labs(y = "Fertility rate (number of births per woman)",
       x = "Average education years among 25+ year-old females")
# View model results
summary(m1)
summary(m2)


