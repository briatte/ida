##
## PACKAGES
##

require(arm)
require(car)
require(downloader)
require(foreign)
require(ggplot2)
require(GGally)

##
## DATA
##

# Download QOG codebook.
if(!file.exists(file <- "data/qog_codebook.pdf"))
  download("http://www.qogdata.pol.gu.se/codebook/codebook_standard_20110406.pdf", file, mode = "wb")

# Download QOG data.
if(!file.exists(file <- "data/qog_cs.dta")) {
  download("http://www.qogdata.pol.gu.se/data/qog_std_cs.dta", file, mode = "wb")
}

# Import.
qog.d <- read.dta(file)

# Check result.
names(qog.d)[1:50]

##
## CORRELATION
##

# Extract UNDP data.
qog.x <- qog.d[, grepl("undp_", names(qog.d))]

# Subset to full data.
qog.x <- na.omit(qog.x)

# Correlation matrix.
cor(qog.x)

# Correlation plot (arm).
corrplot(qog.x, color = TRUE)

# Scatterplot matrix.
pairs(qog.x)

# Scatterplot matrix (car).
scatterplotMatrix(qog.x, spread=FALSE, lty.smooth=2)

# Scatterplot matrix (GGally).
ggpairs(qog.x)

##
## LINEAR REGRESSION
##

# Extract QOG data.
qog <- with(qog.d, data.frame(
  cname = cname,
  ccode = ccodealp,
  fertility = wdi_fr,
  gdpcapita = wdi_gdpc,
  education = bl_asyf25,
  democracy = gol_polreg))

# Subset to full data.
qog <- na.omit(qog)

# Scatterplot.
qplot(data = qog, y = fertility, x = education, label = ccode, geom = "text")

# Simple linear regression.
m1 <- with(qog, lm(fertility ~ education))

# Model summary.
summary(m1)

# Full results.
names(m1)

# Simpler display (arm).
display(m1, digits = 1)

# With p-values.
display(m1, detail = T)

# Coefficients.
coef(m1)

# Coefficient of the intercept.
coef(m1)[1]

# Coefficient of the sole predictor, i.e. slope of the regression line.
coef(m1)[2]

# Base scatterplot.
g <- qplot(data = qog, y = fertility, x = education, geom = "point")
g

# Add regression line.
g <- g + geom_abline(intercept = coef(m1)[1], slope = coef(m1)[2])
g

# Add fitted values.
qog$yhat <- fitted.values(m1)
g <- g + geom_point(y = qog$yhat, color = "blue")
g

# Add residual distance.
str(within(qog, rd <- ifelse(yhat > fertility, "overpredicted", "underpredicted")))
g <- g + geom_segment(y = fitted.values(m1), yend = qog$fertility, 
                 x = qog$education, xend = qog$education, color = "blue")
g

# Residuals versus fitted.
qplot(y = residuals(m1), x = fitted.values(m1), geom = "point") + 
  geom_hline(yintercept = 0) + geom_smooth()

# Distribution of the error term.
qplot(x = residuals(m1), geom = "density")

# Multiple linear regression.
m2 <- with(qog, lm(fertility ~ education + log(gdpcapita) + I(democracy)))

# Simpler display.
display(m2, digits = 1)

# With p-values.
display(m2, detail = T)
