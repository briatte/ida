# Chris Giles:
#
# "Robustness of IMF data scrutinised", Oct 12 2012:
# http://www.ft.com/intl/cms/s/0/85a0c6c2-1476-11e2-8cf2-00144feabdc0.html#axzz2LKQkV3SH
#
# "Has the IMF proved multipliers are really large? (wonkish)" Oct 12 2012:
# http://blogs.ft.com/money-supply/2012/10/12/has-the-imf-proved-multipliers-are-really-large-wonkish/
#
# "The IMF and multipliers, again", Jan 7 2013:
# http://blogs.ft.com/money-supply/2013/01/07/the-imf-and-multipliers-again/

# Chris Hanretty:
# https://gist.github.com/chrishanretty/3885712

## PACKAGES

require(downloader)
require(countrycode)
require(ggplot2)
require(xlsx)

## DATA

# Download.
file = "data/IMFmultipliers.xls"
if(!file.exists(file))
  download("http://interactive.ftdata.co.uk/ft/ftdata/IMFmultipliers.xls", file)

# Import.
imf <- read.xlsx(file,
                 sheetIndex = 2, 
                 rowIndex = c(4:52)[-34], 
                 colIndex = c(1:11, 14:15, 17:20),
                 stringsAsFactors = FALSE,
                 colClasses = c("character", rep("numeric", 15)),
                 header = FALSE)

# Variable names.
names(imf) <- c("Country",
                "gdp_4cast_2011","gdp_4cast_2012",
                "struct_bal_2010","struct_bal_2011","struct_bal_2012",
                "cyc_adj_prim_bal_2010","cyc_adj_prim_bal_2012",
                "gdp_4cast_2011_new","gdp_4cast_2012_new",
                "cumgrowth_2010","cumgrowth_2012","D_growth",
                "D_struct_bal","D_cyc_adj_prim_bal","ca_def")

# Data cleaning.
imf <- within(imf, {
  # fix country codes
  iso3c <- countrycode(Country, "country.name", "iso3c")
  iso3c [ which(imf$Country == "Kosovo") ] <- "KOS"
})

# Subset.
imf <- imf[!is.na(imf$D_struct_bal), ]

# Scatterplot.
imf.plot <- qplot(data = imf, y = D_growth, x = D_struct_bal, 
                  label = iso3c, geom = "text") + 
  labs(x = "Fiscal consolidation", y = "Growth forecast error") + theme_bw()
imf.plot

## MODEL

# Linear regression.
summary(imf.lm <- lm(D_growth ~ D_struct_bal, data = imf))

# Coefficients.
imf.coef <- coef(imf.lm)

# With line.
imf.plot + geom_abline(intercept = imf.coef[1], slope = imf.coef[2])

# With LOESS.
imf.plot + geom_smooth(method = "lm")

## DIAGNOSTICS

# Residuals and fitted values, with diagnostics.
imf.rvf <- data.frame(
  iso3c     = imf$iso3c, 
  residual  = imf.lm$residuals,
  rdist     = abs(imf.lm$residuals),
  yhat      = imf.lm$fitted.values,
  rsta      = rstandard(imf.lm),
  outlier1  = abs(rstandard(imf.lm)) > 2,
  cooksd    = cooks.distance(imf.lm),
  outlier2  = cooks.distance(imf.lm) > 1)

# Concordance of diagnostics.
table(with(imf.rvf, outlier1 == outlier2))

# rvf
imf.rvfplot <- qplot(data = imf.rvf, y = residual, x = yhat, label = iso3c, geom = "text") + 
  geom_hline(y = 0, linetype = "dotted") + 
  labs(y = "Residuals", x = "Fitted values") + theme_bw()
imf.rvfplot

# With LOESS.
imf.rvfplot + geom_smooth(se = FALSE)

# With color by residual distance.
imf.rvfplot + aes(color = rdist) + 
  scale_colour_gradient(name = "Residual\ndistance", low = "black", high = "red")

# With color by residual distance, using circles and a 2-color scale.
imf.rvfplot + geom_point(aes(color = rdist), size = 18, alpha = .3) + 
  scale_colour_gradient2(name = "Residual\ndistance", 
                         low = "green", mid = "orange", high = "red",
                         midpoint = mean(imf.rvf$rdist))

# Variations with Cook's D:
imf.rvfplot + aes(color = outlier2) + 
  scale_colour_manual(name = "Cook's D > 1", values = c("black", "red"))

imf.rvfplot + aes(color = cooksd) + 
  scale_colour_gradient(name = "Cook's D", low = "black", high = "red")

imf.rvfplot + geom_point(aes(color = cooksd), alpha = .5, size = 18) +
  scale_colour_gradient(name = "Cook's D", low = "white", high = "red")

imf.rvfplot + 
  geom_point(data = subset(imf.rvf, outlier2 == TRUE), color = "red", size = 18, alpha = .4)

# Variations with rsta:
imf.rvfplot + aes(y = rsta) + labs(y = "Standardized residuals") +
  geom_hline(y = c(-2, 2), linetype = "dotted")

imf.rvfplot + aes(y = rsta) + labs(y = "Standardized residuals") +
  geom_hline(y = c(-2, 2), linetype = "dotted") + 
  geom_point(data = subset(imf.rvf, outlier1 == TRUE), color = "red", size = 18, alpha = .4)

# Normality of standardized residuals.
qplot(sample = rsta, data = imf.rvf) + 
  geom_abline(linetype = "dotted")

# With country codes.
ggplot(imf.rvf, aes(sample = rsta)) + 
  geom_text(label = imf.rvf$iso3c, stat="qq") + 
  geom_abline(linetype = "dotted")

# Store the plot data.
imf.qq <- ggplot_build(imf.qqplot)$data[[1]]

# Add country codes.
imf.qq <- within(imf.qq, {
  delta = abs(sample - theoretical)
  iso3c <- imf.rvf$iso3c[order(imf.rvf$rsta)]
})

# Plot again with country codes.
qplot(data = imf.qq, x = theoretical, y = sample, label = iso3c, geom = "text") +
  geom_abline(linetype = "dotted") + theme_bw()

# Plot again with colored circles.
qplot(data = imf.qq, x = theoretical, y = sample, size = I(18), alpha = I(.2), geom = "point") + 
  aes(color = delta) + scale_color_gradient(name = "Deviation", low = "white", high = "red") + 
  geom_text(aes(label = iso3c)) + 
  geom_abline(linetype = "dotted") + theme_bw()

# send to Financial Times, get published, like a boss
# 2013-03-11
