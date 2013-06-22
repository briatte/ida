
## IDA Session 7
## -------------


# Package loading
# ---------------

# Load/install packages.
packages <- c("countrycode", "ggplot2", "Hmisc", "plyr", "scales")
packages <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})


# DATA PREPARATION
# ----------------

# Let's first review some of the things that we now know how to do with data.

# Load dataset.
qog_cs <- read.csv("data/qog_basic_cs.csv")

# Create an extract of the QOG cross-sectional dataset. The list of variables is
# quasi-identical to the one used previously, with an extra variable for regions.
qog <- with(qog_cs, data.frame(
  row.names  = cname, # Country name (set as row name in the data extract)
  ccode  = ccodealp,  # Country 3-letter code
  region = ht_region, # Geographical region of the country
  births = wdi_fr,    # Fertility rate
  gdpc   = wdi_gdpc,  # GDP per capita
  gexp   = wdi_ge,    # Government expenditures as percentage of GDP
  hexpc  = wdi_hec,   # Health care expenditure per capita
  gini   = uw_gini,   # GINI coefficient of economic inequality 
  edu    = bl_asyt25, # Average years of schooling
  gris   = wdi_gris,  # Female to male ratio in schools
  winpar = m_wominpar # Percentage of women in parliament
))


# Geographic indicators
# ---------------------

# Let's now see what kind of geographic descriptors we have in the dataset.
# The first one is a list of ISO-3 country codes, an international standard.
levels(qog$ccode)

# This list has been supplemented, in the QOG dataset, by a geographic variable
# combining spatial proximity and expert decisions on regional democratization.
str(qog$region)

# An issue here is that we imported the data without its labels, so the regions
# are uninformative. But with ISO-3 country codes, we can recreate UN regions.
table(countrycode(qog$ccode, "iso3c", "region"))

# We save the UN continent instead to create groups with many countries each.
qog$region <- with(qog, countrycode(ccode, "iso3c", "continent"))

# Check result.
qplot(qog$region, geom = "bar")


# Missing data
# ------------

# Some entries in the QOG dataset are not recognized as UN countries.
rownames(qog)[is.na(qog$region)]

# Drop these cases, that have been counted in other country indicators.
qog <- subset(qog, !is.na(region))

# The analysis that we will run today also runs faster without missing data.
# Let's identify the rows with missing data.
qog$fulldata <- complete.cases(qog)

# Check result. The complete.cases() function is a utility function that will
# return TRUE if there is absolutely no missing data on a row of the dataset.
table(qog$fulldata)

# Identify where the missing data lies. There is a lot, so we will remember that
# when we look at plots and reading the results of statistical tests.
qplot(data = qog, x = region, fill = fulldata, geom = "bar")

# Subset to full data rows.
qog <- na.omit(qog)


# Reordering factors
# ------------------

# In R, sorting the data is different from ordering levels in a variable.
# Let's see how to sort the data from highest to lowest fertility rates.
by_births <- order(qog$births, decreasing = TRUE)

# Show the first three columns in that sorting order.
head(qog[by_births, 1:3])

# For ascending sort order, you would simply not specify the decreasing option.
head(qog[order(qog$births), 1:3])

# Countries for which fertility rates are missing are always sorted last.
tail(qog[order(qog$births), 1:3])

# But this is different from the order of a string variable like country codes.
# The country code variable holds text, coded as factors and ordered by levels.
str(qog$ccode)

# An issue here is that R naturally orders factors by alphabetical order, which
# is not optimal for ordering categorical variables like countries in plots.

# Here's an example where countries are alphabetically ordered.
qplot(data = qog[1:25, ], y = ccode, x = births, color = region, geom = "point")

# Now, reorder country code factor levels by their respective fertility rates.
qog$ccode <- with(qog, reorder(ccode, births, mean))

# The example now shows countries ordered by fertility rates.
qplot(data = qog[1:25, ], y = ccode, x = births, color = region, geom = "point")

# Let's now visualize the distribution of fertility rates in each region.
qplot(data = qog, x = births, fill = region, color = region, geom = "density") +
  facet_grid(region ~ .)

# The regions are shown in alphabetical order. Let's fix that.
qog$region <- with(qog, reorder(region, -births, mean))

# Rerun the plot to see regions ordered by average fertility rates.
qplot(data = qog, x = births, fill = region, color = region, geom = "density") +
  facet_grid(region ~ .)

# These manipulations show how to plot distributions as densities and how to use
# the mean value of a distribution to summarize it. More after our last recodes.


# Log transformation
# ------------------

# Let's turn to a different variable: GDP per capita.
qplot(data = qog, x = region, y = gdpc, color = region, geom = "boxplot")

# For such a variable, a log-transformation helps.
qplot(data = qog, x = region, y = log(gdpc), color = region, geom = "boxplot")

# What exactly are we doing here? We are basically compressing the distribution
# of the variable to get outliers in closer range to other observations.

# Let's look at the distribution of GDP per capita more closely to get that.
summary(qog$gdpc)

# The maximum value is pretty far away from the median value.
with(qog, max(gdpc) / median(gdpc))

# Order the data by GDP per capita.
qog <- qog[order(qog$gdpc, decreasing = TRUE), ]

# Get the five leader countries.
head(qog)[1:4]

# Now reorder the levels of the country code factor variable by GDP per capita.
qog$ccode <- reorder(qog$ccode, qog$gdpc, mean)

# In fact, the top 5-10% observations are just on a completely different level.
qplot(data = qog, x = gdpc, stat = "ecdf", geom = "step")

# This curve is the empirical cumulative distribution function (ECDF) of the
# variable: it shows how its values change throughout its quantiles.

# Here's the ECDF for each region: see which one creates most variation.
qplot(data = qog, x = gdpc, stat = "ecdf", color = region, geom = "step")

# Now see what happens to the ECDFs when you log the variable.
qplot(data = qog, x = log(gdpc), stat = "ecdf", color = region, geom = "step")

# The overall distribution of log-GDP per capita is more linear.
qplot(data = qog, x = log(gdpc), stat = "ecdf", geom = "step")

# Log-transform GDP per capita.
qog$gdpc <- log(qog$gdpc)


# Interval recodes
# ----------------

# Let's turn to yet another variable: government expenditure as % of GDP.
qplot(data = qog, x = region, y = gexp, color = region, geom = "boxplot")

# The plots show great variability of government expenditure within regions.
qplot(data = qog, x = gexp, color = region, fill = region, geom = "density") + 
  facet_grid(region ~ .)

# Let's try a 'Hans Rosling' genius plot: a stacked density plot by region.
qplot(data = qog, x = gexp, ..density.., geom = "density", 
      color = region, fill = region, alpha = I(.75), position = "stack")

# However, this plot does not preserve the count of each region. This one does.
qplot(data = qog, x = gexp, ..count.., geom = "density", 
      color = region, fill = region, alpha = I(.75), position = "fill")

# One option now is to recode this continuous variable to categories of low,
# medium and high government expenditure, for instance. How do we get there?

# Let's recode some continuous variables into categorical ones by dividing them
# into two equally sized groups defined by their median (50th percentile) value.

# Summarize the variable.
summary(qog$gexp)

# The quartiles and median are the 25th, 50th and 75th percentiles. They can be
# used to "cut" the variable to intervals. First, compute the quartile values.
q <- quantile(qog$gexp)

# Check the quartile values.
q

# Plot regional distributions of government expenditures with sample quartiles.
qplot(data = qog, x = gexp, color = region, fill = region, geom = "density") + 
  geom_vline(x = q, linetype = "dashed") + facet_grid(region ~ .)

# Now create a new variable by using these cutoff points as interval categories.
qog$gexp.4 <- cut(qog$gexp, breaks = q)

# Check the interval categories. 
table(qog$gexp.4)

# Check them with boxplots.
qplot(data = qog, y = gexp, x = gexp.4, geom = "boxplot")

# Stack them by region.
g <- qplot(data = qog, x = region, fill = gexp.4, geom = "bar")

# Check result, which is unsatisfactory with default colors and missing values.
g

# Plot with blue sequential gradient. 
g + scale_fill_brewer()

# Plot with red-blue diverging gradient.
g + scale_fill_brewer(palette = "RdBu")

# Back to the data. We are going to produce interval recodes for all variables,
# using a very simple cutoff point for the values: above or below the median.

# Define a function to cut the data at median and label segments "lo" and "hi".
hilo <- function(x) { 
  cut(x, breaks = quantile(x, probs = 0:2/2), labels = c("lo", "hi"), 
      ordered = TRUE, include.lowest = TRUE)
}

# Apply to all continuous variables.
x <- lapply(qog[, 3:10], FUN = hilo)

# Rename variables with original names, followed by ".2" to discriminate them.
names(x) <- paste0(names(x), ".2")

# Convert to data frame and check result.
str(x)

# Add these variables to the original QOG data.
qog <- cbind(qog, as.data.frame(x))

# Check final result.
str(qog)

# Let's tell R to look in the QOG data for any variable we mention subsequently.
# The command saves us time and frees us from the need to call the qog object in
# in front of every variable call (e.g. qog$births). To cancel the attachment,
# we will type detach(qog) when were are done.

attach(qog)


# DESCRIPTIVE STATISTICS
# ----------------------

# What's on the menu here? Take a variable like log-GDP per capita. This is the
# distribution, a.k.a the probability density function (PDF) of the variable.
qplot(gdpc, geom = "density")

# It is easier to read it in natural units (constant USD), so exponentiate it.
qplot(exp(gdpc), geom = "density")

# And now have a look again at which countries compose the distribution.
qplot(exp(gdpc), ..count.., geom = "density", 
      color = region, fill = region, alpha = I(.75), position = "stack")

# For such a variable, the mean and the median can describe the distribution.
# Now turn again to some previously studied examples of categorical variables.

# Frequencies of government expenditure in each region.
qplot(x = region, fill = gexp.4, geom = "bar")

# Plot stacked (relative) frequencies of government expenditure in each region.
qplot(x = region, fill = gexp.4, geom = "bar", position = "fill") + 
  scale_y_continuous(labels = percent) + scale_fill_brewer()

# Here, frequencies and relative frequencies (percentages) make sense.
# The next sections show to produce these summary statistics.


# Continuous (and ordinal) measures
# ---------------------------------

# Standard summary statistics (the 'five-number summary' figures).
summary(qog[, 3:9])

# Obtain summary statistics for the fertility rate:

# (1) Range
max(births)
min(births)

# (2) Arithmetic mean
mean(births)
sum(births) / length(births) # formula

# (3) Standard deviation
sd(births)
sqrt(sum((births - mean(births))^2) / length(births)) # formula: sqrt(var(x))

# (4) Median
median(births)
quantile(births, probs = .5) # 50th percentile

# (5) Percentiles
quantile(births) # quartiles
quantile(births, probs = c(0.1, 0.9)) # specific cutoff points


# Plots for continuous variables
# ------------------------------

# Histograms.
hist(births, main="Histogram of Fertility in 81 countries")
hist(births, br = 20)

# For normality assessment, you first want to visualize the normal distribution.
curve(dnorm, from = -3, to = 3, col = "red", lwd = 2)

# Then you want to visualize the quantiles of your variable against normal ones.
# Say hello to the normal quantile-quantile ('QQ') plot.
qqnorm(births)

# And finally you want to add a line that would correspond to perfect normality.
# Note that this command requires that you have just plotted a normal QQ-plot.
qqline(births, col = "red")

# More default plots.
stripchart(births, method = "jitter", main = "Stripchart with jitter")
boxplot(births, main = "Boxplot")

# For a continuous and a categorical variable, boxplots have an easy syntax.
boxplot(births ~ region)
boxplot(births ~ gini.2)

# The next plots go further than the default R syntax. You need to learn ggplot2
# to get the syntax. An awesome handbook is Winston Chang's R Graphics Cookbook.

# Histograms, using ggplot2 syntax.
qplot(births)
qplot(births, binwidth = 1)
ggplot(qog, aes(x = births)) +
  geom_histogram(binwidth = 1, fill = "white", color = "black")

# Density plots, using ggplot2 syntax.
qplot(births, geom = "density")
qplot(births, stat = "density", geom = "line")

# Combined histogram and density plots.
ggplot(qog, aes(x = births, y = ..density..)) +
  geom_histogram(binwidth = 1, fill = "cornsilk", color = "grey50") +
  geom_line(stat = "density", size = 2)

# Normal QQ-plot.
qplot(sample = births)
qplot(sample = births, color = region)

# Boxplots.
qplot(y = births, x = region, geom = "boxplot")
qplot(y = births, x = region, geom = "boxplot") + geom_point(alpha = .5)
qplot(y = births, x = region, geom = "boxplot") + aes(fill = gris.2)
qplot(y = births, x = region, geom = "boxplot") + aes(fill = gris.2) + coord_flip()

# Violin plots.
qplot(y = births, x = region, geom = "violin") + geom_point()
qplot(y = births, x = region, geom = "violin") + geom_point(alpha = .5)


# Categorical (and ordinal) measures
# ----------------------------------

# Obtain frequencies (count and relative) for geographic regions:

table(region)                            # frequencies by category
prop.table(table(region))                # in proportions
round(prop.table(table(region)), 1)      # rounded to one decimal point
round(100 * (prop.table(table(region)))) # shown in percentages

# R was clearly not designed by people who use percentages a lot.
# Let's write a function to do this in as less code as possible.

percents <- function(r, c, which = 0, digits = 1) {
  if(which == "rows") which = 1
  if(which == "cols") which = 2
  if(which == "cell" | which == 0) which = NULL
  round(100 * prop.table(table(r, c), which), digits)
}

# Cell percentages.
percents(region, births.2)

# Check that the function works.
sum(percents(region, births.2, "cell")) # this is the default

# Row percentages.
percents(region, births.2, "rows") # you can use 1 instead of "rows"

# Column percentages.
percents(region, births.2, "cols") # you can use 2 instead of "cols"


# Plots for categorical variables
# -------------------------------

# Default bar/dot plots, for categorical variables.
barplot(table(region))
barplot(table(region), horiz = TRUE)
dotchart(table(region), cex = 1)

# For a pair of categorical variables, use mosaic plots.
mosaicplot(table(region, births.2), col = TRUE)
mosaicplot(table(gini.2, births.2), col = TRUE)

# And finally, the infamous pie chart that makes R look like Excel 97.
pie(table(region))

# Using ggplot2 syntax, we can show how to transform bars into polar coordinates
# (which is, again, a perceptual nightmare for the reader).

# Bar plots.
qplot(region, geom = "bar")
qplot(region, geom = "bar", fill = gexp.4) + coord_flip()

# "This is a pie of my favourite bars" (Barney Stinson).
qplot(region, geom = "bar", fill = gexp.4) + coord_polar() + 
  scale_fill_brewer(palette = "RdBu")

# Dot plots.
qplot(region, geom = "point")


# ASSOCIATION TESTS
# -----------------


# Significance testing revolves around the idea that a statistic, whatever it
# might stand for, can be estimated to be significantly different from zero.
# One of the simplest forms of test, the t-test, is shown below.
t.test(births)

# The bounds of the test form a confidence interval: the range in which the
# test estimates that the mean of the fertility rate is located. The width of
# the interval depends on both the sample size and the level of confidence.
c(t.test(births)$conf.int[1], mean(births), t.test(births)$conf.int[2])


# Confidence intervals
# --------------------

# Here's the manual way to obtain a confidence interval, based on the assumption
# that the data follows some approximation of the normal distribution. We first
# compute the mean, standard deviation and N of fertility rates in each region.
ci <- ddply(qog, .(region), summarise, 
      mu = mean(births), 
      sd = sd(births), 
      n  = length(births))

# We now turn to the standard error, which is an approximation of the standard
# deviation of the data in the true population (each region), assuming that it
# can be approximated from the sample standard deviation divided by sqrt(N).
ci$se <- ci$sd / sqrt(ci$n) 

# We finally decide for a 95% level of confidence that corresponds roughly to
# two standard errors around the mean. In a normal distribution, roughly 95%
# of all observations fall within this range around the mean.
ci$lo <- ci$mu - 1.96 * ci$se
ci$hi <- ci$mu + 1.96 * ci$se

# Plot 95% CIs.
qplot(data = ci, x = region, y = mu, fill = region, stat = "identity", geom = "bar") + 
  geom_errorbar(aes(ymax = hi, ymin = lo), width = .25)

# Plot 99% CIs.
qplot(data = ci, x = region, y = mu, fill = region, stat = "identity", geom = "bar") + 
  geom_errorbar(aes(ymax = mu + 2.58 * se, ymin = mu - 2.58 * se), width = .25)

# Throw all this code into a convenience function.
getCI <- function(data, x, group, z = 1.96) {
  require(plyr)
  df <- with(data, data.frame(x, group, z, n = 1))
  df <- na.omit(df)
  print(head(df))
  ci <- ddply(df, .(group), summarise,
              mu = mean(x),
              sd = sd(x),
              n  = sum(n),
              se = sd(x) / sqrt(sum(n)),
              lo = mean(x) - mean(z) * sd(x) / sqrt(sum(n)),
              hi = mean(x) + mean(z) * sd(x) / sqrt(sum(n)))
  return(ci)
}

# Test by getting 95% CIs for fertility in the high and low GINI country groups.
ci <- getCI(qog, births, gini.2)

# Plot the result.
qplot(data = ci, x = group, y = mu, fill = group, stat = "identity", geom = "bar") + 
  geom_errorbar(aes(ymax = hi, ymin = lo), width = .25) +
  labs(y = "Mean fertility rate", x = "Level of GINI coefficient")

# Test by getting 95% CIs for fertility in the high and low GINI country groups.
ci <- getCI(qog, births, gdpc.2)

# Plot the result.
qplot(data = ci, x = group, y = mu, fill = group, stat = "identity", geom = "bar") + 
  geom_errorbar(aes(ymax = hi, ymin = lo), width = .25) +
  labs(y = "Mean fertility rate", x = "Level of GDP per capita")

# In truth, this is typically the case where we would be graphing scatterplots.
qplot(births, gdpc) + geom_smooth()

# ... but that will have to wait one more week :)


# With two categorical variables
# ------------------------------

chisq.test(table(region, births.2))  # Chi-squared test of independence
fisher.test(table(region, births.2)) # if cell counts < 5, Fisher's test is recommended

chisq.test(table(gini.2, births.2))
chisq.test(table(gdpc.2, births.2))
chisq.test(table(gexp.2, births.2)) # etc.

# With one continuous variable and a binary variable
# --------------------------------------------------

t.test(births ~ gini.2)
t.test(births ~ gdpc.2)
t.test(births ~ gexp.2) # etc.

detach(qog)


# That's all for now! Enjoy your day.
# 2013-02-18
