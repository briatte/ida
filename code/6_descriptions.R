## IDA Session 6
## -------------

# Load/install packages.
packages <- c("gplots", "ggplot2", "Hmisc", "car", "gmodels")
packages <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})

# Load dataset.
qog_cs <- read.csv("data/qog_basic_cs.csv")

# The list of variables is quasi-identical to the one used previously.
# Let's simply add an extra variable coding for geographical regions.
qog <- with(qog_cs, data.frame(
  ccode  = ccodealp, # country three letter code
  cname  = cname,    # country name
  region = ht_region,# region of country
  births = wdi_fr,   # fertility rate
  gdpc   = wdi_gdpc, # GDP per capita
  gexp   = wdi_ge,   # government expenditures as percentage of GDP
  hexpc  = wdi_hec,  # health care expenditure per capita
  gini   = uw_gini,  # GINI coefficient of inequality 
  edu    = bl_asyt25,# average years of schooling
  gris   = wdi_gris, # female to male ratio in schools
  winpar = m_wominpar # percentage of women in parliament
))

# Clean up missing data.
qog <- na.omit(qog)
# Clean up row names.
rownames(qog) <- NULL
# Reorder country factor levels by their respective fertility rates.
qog$cname <- with(qog, reorder(cname, births))


# Recodings
# ---------

# Define shorter labels for geographical regions.
qog_regions <- c("EEur", "LatAm", "NAfr&MEast", "SubSAfr", "WEur&NAm", "EAsia", "SEAsia", "SAsia", "Pacif", "Carib")

# Assign value labels to the region variable.
qog$region <- factor(qog$region, levels = c(1:10), labels = qog_regions)

# Let's recode some continuous variables into categorical ones by dividing them
# into two equally sized groups defined by their median (50th percentile) value.
# This will be useful for presenting some of the stats and graphs. Let's start
# with a short demo that we won't save but only try out before applying it.

# Define a three-level sequence to be used as interval cutoff points.
s <- 0:2/2
# Define the levels that will describe the two resulting categories.
l <- c("lo", "hi")
# Get the 0.5-th quantile (the median, or 50th percentile) of a variable.
q <- quantile(qog$births, probs = s)
# Divide the variable into its lower [0, .5) and upper [.5, 1] quantiles.
cut(qog$births, breaks = q, labels = l, ordered = TRUE, include.lowest = TRUE)

# The lapply() function below applies this transformation to all variables.
qog_cat <- lapply(qog[, 4:11], FUN = function(x){
  s <- 0:2/2
  l <- c("lo", "hi")
  q <- quantile(x, probs = s)
  cut(x, breaks = q, labels = l, ordered = TRUE, include.lowest = TRUE)
})
# Check result.
qog_cat
# Convert result to data frame.
qog_cat <- data.frame(qog_cat)
# Add categorical descriptors.
qog_cat <- cbind(qog[, 1:3], qog_cat)

# Finally, let's tell R to look in the qog subset for any variable we mention subsequently.
# The command saves us time and frees us from the need to type "qog$" in front of every variable call.
# The command will be canceled as follows: detach(qog)

attach(qog)


# Descriptive univariate statistics
# ---------------------------------

# Basic commands for continuous (and ordinal) measures.

# Standard summary statistics.
describe(qog)
summary(qog)

# Obtain specific statistics.
max(births)
min(births)
mean(births)
median(births)
sd(births)
quantile(births)
quantile(births, probs = c(0.1, 0.9)) # specific cutoff points

# Basic commands for categorical (and ordinal) measures.

table(region)                          # frequencies by category
prop.table(table(region))              # in proportions
round(prop.table(table(region)), 2)    # rounded to two decimals points
round(100*(prop.table(table(region)))) # shown in percentages


# Plots
# -----

# Default histograms, for continuous variables.
hist(births, main="Histogram of Fertility in 81 countries")
hist(births, br = 20)
# Using ggplot2 syntax.
qplot(births)
qplot(births, binwidth = 1)
# Density plot.
qplot(data = qog, x = births, geom = "density")

# Other default graphs.
stripchart(births, method="jitter", main="Stripchart with Jitter")
boxplot(births, main="Boxplot of Fertility in 81 countries")
qqnorm(births)
qqline(births)

# Default bar/dot plots, for categorical variables.
barplot(table(region))
barplot(table(region), horiz = TRUE)
dotchart(table(region), cex = 1)
# Using ggplot2 syntax.
qplot(region, geom = "bar")
qplot(region, geom = "bar") + coord_flip()

# Never, ever use that plot type...
pie(table(region))
# ... unless the area is meaningful.
qplot(region, geom = "bar") + coord_polar()

detach(qog)


# Descriptive bivariate statistics
# --------------------------------

attach(qog_cat)

# For a pair of categorical variables:
table(region, births)                               # frequencies
round(100*(prop.table(table(region, births))),2)    # total percentages
round(100*(prop.table(table(region, births),1)),2)  # row percentages
round(100*(prop.table(table(region, births),2)),2)  # column percentages


# Plots
# -----

# For a pair of categorical variables:
mosaicplot(table(region, births), col = TRUE)
mosaicplot(table(gini, births), col=TRUE)

detach(qog_cat)

# For a continuous and a categorical variable:
boxplot(qog$births ~ qog$region)
qplot(data = qog, region, births, geom = c("boxplot", "point"))

# Variations on box plots:
boxplot(qog$births ~ qog_cat$gini)
qplot(data = qog, gini, births, geom = c("boxplot", "point"))
qplot(data = qog, region, births, geom = "boxplot", color = qog_cat$gini) + coord_flip()


# Association tests
# -----------------

attach(qog_cat)

table(region, births)

# Test of independence of a pair of categorical variables:
chisq.test(table(region, births))  # Chi-squared test of independence
fisher.test(table(region, births)) # if cell counts < 5, this test is more appropriate

chisq.test(table(gini, births))
chisq.test(table(gdpc, births))
chisq.test(table(gexp, births)) # etc.

detach(qog_cat)

attach(qog)

# Test of independence of a binary and a continuous variables
t.test(births ~ qog_cat$gini)
t.test(births ~ qog_cat$gdpc)
t.test(births ~ qog_cat$gexp) # etc.

# Confidence intervals
t.test(births)

# The barplots below will not work for regions because some categories have too
# few cases to estimate the confidence intervals properly.
b_gini_mean <- tapply(births, qog_cat$gini, mean)
lower <- tapply(births, qog_cat$gini, function(v) t.test(v)$conf.int[1])
upper <- tapply(births, qog_cat$gini, function(v) t.test(v)$conf.int[2])
barplot2(b_gini_mean, plot.ci = TRUE, ci.l = lower, ci.u = upper)

b_gdpc_mean<-tapply(births, gdpc2, mean)
lower <- tapply(births, gdpc2, function(v) t.test(v)$conf.int[1])
upper <- tapply(births, gdpc2, function(v) t.test(v)$conf.int[2])
barplot2(b_gdpc_mean, plot.ci = TRUE, ci.l = lower, ci.u = upper)

b_gexp_mean<-tapply(births, gexp2, mean)
lower <- tapply(births, gexp2, function(v) t.test(v)$conf.int[1])
upper <- tapply(births, gexp2, function(v) t.test(v)$conf.int[2])
barplot2(b_gexp_mean, plot.ci = TRUE, ci.l = lower, ci.u = upper)

b_gris_mean<-tapply(births, gris2, mean)
lower <- tapply(births, gris2, function(v) t.test(v)$conf.int[1])
upper <- tapply(births, gris2, function(v) t.test(v)$conf.int[2])
barplot2(b_gris_mean, plot.ci = TRUE, ci.l = lower, ci.u = upper)

b_winpar_mean<-tapply(births, winpar2, mean)
lower <- tapply(births, winpar2, function(v) t.test(v)$conf.int[1])
upper <- tapply(births, winpar2, function(v) t.test(v)$conf.int[2])
barplot2(b_winpar_mean, plot.ci = TRUE, ci.l = lower, ci.u = upper)

# That's all for now! Enjoy your day.
# 2013-02-18
