
## IDA Exercise 8
## --------------


# This exercise replicates results from the IMF World Economic Outlook 2012.
# The code is loosely adapted from a replication script by Chris Hanretty.

# You will need to read Chris Giles' articles in the Financial Times to get
# the point of the model, and to understand what to interpret in the results.


# Packages
# --------

require(arm)
require(downloader)
require(countrycode)
require(ggplot2)
require(xlsx)


# Data preparation
# ----------------

# Download XLS spreadsheet. Chris Giles collected the data from the IMF. The
# data used in the World Economic Outlook 2012 is in the second spreadsheet.
file = "data/IMFmultipliers.xls"
if(!file.exists(file))
  download("http://interactive.ftdata.co.uk/ft/ftdata/IMFmultipliers.xls", 
           file, mode = "wb")

# Import XLS format. The read.xlsx() function was already shown in Session 4 on
# data import/export. If it fails to work, check that the data downloaded fine.
imf <- read.xlsx(file,
                 sheetIndex = 2, 
                 rowIndex = c(4:52)[-34], 
                 colIndex = c(1:11, 14:15, 17:20),
                 stringsAsFactors = FALSE,
                 colClasses = c("character", rep("numeric", 15)),
                 header = FALSE)

# Fix variable names, drawing largely on the names used by Chris Hanretty's own
# replication code. We include many more variables than those used afterwards.
names(imf) <- c("Country",
                "gdp_4cast_2011","gdp_4cast_2012",
                "struct_bal_2010","struct_bal_2011","struct_bal_2012",
                "cyc_adj_prim_bal_2010","cyc_adj_prim_bal_2012",
                "gdp_4cast_2011_new","gdp_4cast_2012_new",
                "cumgrowth_2010","cumgrowth_2012","D_growth",
                "D_struct_bal","D_cyc_adj_prim_bal","ca_def")

# Fix country codes. 'ISO3C' is a numeric standard for country codes, which we
# already used when we previously explored the Quality of Government dataset.
imf$iso3c <- countrycode(imf$Country, "country.name", "iso3c")
imf$iso3c [ which(imf$Country == "Kosovo") ] <- "KOS"

# Subset to full data. This results in a dataset slightly larger than the one
# used by the IMF, as Chris Giles points out in his own analysis of the data.
imf <- imf[!is.na(imf$D_struct_bal), ]

# Draw the scatterplot corresponding to Figure 1.1.1 in the IMF World Economic
# Outlook 2012 report (p. 41). Country codes are shown instead of data points.
imf.plot <- qplot(data = imf, y = D_growth, x = D_struct_bal, 
                  label = iso3c, geom = "text") + 
  labs(x = "Fiscal consolidation", y = "Growth forecast error")
imf.plot


# Regression model
# ----------------

# Simple linear regression. The equation is written in the form y ~ x, where y
# is the dependent variable and x is its predictor, or independent variable.
summary(imf.lm <- lm(D_growth ~ D_struct_bal, data = imf))

# Get the coefficients of the model. Read the help page for the coef() function
# to learn more about the convenience functions that can extract model results.
imf.coef <- coef(imf.lm)

# Check results. The coefficient for the difference in structural balance should
# approach the result obtained by Chris Giles with the same dataset, i.e. -.67.
imf.coef

# Add a regression line. The line has an equation of the form y = a + bx where
# b is the slope of the line and a is its coordinate at origin, or intercept. 
imf.plot + geom_abline(intercept = imf.coef[1], slope = imf.coef[2])

# Add a LOESS curve to show a smoothed trend through the data Specifying a 
# linear method (lm) will draw a confidence interval around the regression line. 
imf.plot + geom_smooth(method = "lm")


# Diagnostics
# -----------

# Create a data frame from the residuals and fitted values of the model, with 
# markers to detect outliers using Cook's distance and standardized residuals.
imf.rvf <- data.frame(
  iso3c     = imf$iso3c, 
  yhat      = imf.lm$fitted.values,       # predicted (fitted) values
  residual  = imf.lm$residuals,           # raw (unstandardized) residuals
  rdist     = abs(imf.lm$residuals),      # absolute residual distance
  rsta      = rstandard(imf.lm),          # standardized residuals
  outlier1  = abs(rstandard(imf.lm)) > 2, # high standardized residuals
  cooksd    = cooks.distance(imf.lm),     # Cook's distance
  outlier2  = cooks.distance(imf.lm) > 1) # high Cook's distance

# Check outliers concordance. Cook's distance and standardized residuals should
# return more or less the same results, so this table should be mostly TRUE.
table(with(imf.rvf, outlier1 == outlier2))

# Draw a residuals-versus-fitted-values plot. The distance between each data
# point and the zero reference line is the error term for the observation.
imf.rvfplot <- qplot(data = imf.rvf, y = residual, x = yhat, 
                     label = iso3c, geom = "text") + 
  geom_hline(y = 0, linetype = "dotted") + 
  labs(y = "Residuals", x = "Fitted values")
imf.rvfplot

# Add a LOESS curve to show a smoothed trend through the residuals. The trend
# should more or less follow the zero reference line if the model is balanced.
imf.rvfplot + geom_smooth(se = FALSE)

# Add color to highlight the observations with high residual distance, i.e. high
# error terms. Countries highlighted in red are poorly predicted by the model.
imf.rvfplot + aes(color = rdist) + 
  scale_colour_gradient(name = "Residual\ndistance", low = "black", high = "red")

# Add color by residual distance, using circles and a 2-color scale. This is our
# best shot at showing where the model fails to predict the dependent variable.
imf.rvfplot + geom_point(aes(color = rdist), size = 18, alpha = .3) + 
  scale_colour_gradient2(name = "Residual\ndistance", 
                         low = "green", mid = "orange", high = "red",
                         midpoint = mean(imf.rvf$rdist))

# The next plot uses Cook's distance (Cook's D) to detect the outliers. This
# method is used in the IMF World Economic Outlook 2012 report (p. 42).
imf.rvfplot + aes(color = outlier2) + 
  scale_colour_manual(name = "Cook's D > 1", values = c("black", "red"))

# We prefer to use standardized residuals because they read more intuitively.
# The result is almost the same as with Cook's D, with one additional outlier.
imf.rvfplot + aes(y = rsta) + labs(y = "Standardized residuals") +
  geom_hline(y = c(-2, 2), linetype = "dotted") + 
  geom_point(data = subset(imf.rvf, outlier1 == TRUE), 
             color = "red", size = 18, alpha = .4)

# We last check the normality of the residuals: departures from the dotted line
# indicates where the model fails to produce a normally distributed error term.
qplot(sample = residual, data = imf.rvf) + 
  geom_abline(linetype = "dotted")

# Now send that to the Financial Times and get published like a boss.
# 2013-03-11
