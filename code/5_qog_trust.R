
# Load/install packages.
packages <- c("ClustOfVar", "countrycode", "devtools", "FactoMineR", "foreign", "ggplot2")
packages <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})

########
# DATA #
########

# Quality of Government, Stata version.
# Thanks to the OQG team and to the Swedish taxpayer.
qog <- read.dta("data/qog-cs.dta")

# Copy ISO-3C country code to row names.
row.names(qog) <- qog$ccodealp

# The next block takes advantage of the Stata format, which includes variable labels (short text descriptions). By default, the labels are stored as dataset attributes: the next code block copies them to the variable names and then subsets the data to variables featuring the keyword "confidence" in their description.

# Copy Stata label over variable names.
names(qog) <- attr(qog, "var.labels")

# Subset to variables with "confidence" in their name.
qog <- qog[, grepl("confidence", names(qog), ignore.case = TRUE)]

# Clean up variable names.
names(qog) <- gsub("Confidence: |the ", "", names(qog))

# Remove a few columns with less observations.
qog <- qog[, !names(qog) %in% c("European Union", "NATO", "social security")]

# Subset to nonmissing data.
qog <- na.omit(qog)

# Finalized dataset.
str(qog)

# Countries considered.
row.names(qog)

# Extract regions.
table(countrycode(row.names(qog), "iso3c", "region"))

# Trim numbers.
qog.trust.regions <- substring(qog.trust.regions, 4)

########################
# PCA, with FactoMineR #
########################

# The two-lines approach.
qog.PCA <- PCA(qog.trust, graph = FALSE)
plot(qog.PCA)

# with ggplot, you need the standard prcomp object:
qog.prcomp <- prcomp(qog.trust, scale = TRUE)
qog.prcomp <- prcomp(qog.trust, scale = TRUE)

library(devtools)

install_github("ggbiplot", "vqv")
library(ggbiplot)

ggbiplot(qog.prcomp, 
#	labels = rownames(qog.trust), 
	groups = countrycode(rownames(qog.trust), "region"),
	ellipse = TRUE) + 
	theme(
		legend.position = "bottom",
		legend.direction = "vertical",
		legend.margin = unit(1, "cm")
	) +
	scale_color_brewer(name = "", palette = "Set1")

# create variable for regional grouping
qog.trust.region <- qog$'The Region of the Country'[qog$'Country Name' %in% row.names(qog.trust)]

# add a ggplot2 biplot function:
require(devtools)
install_github("ggbiplot", "vqv")
require(ggbiplot)

# plot (shows that it would be better to exclude Turkey):
g <- ggbiplot(qog.prcomp, obs.scale = 1, var.scale = 1,
              groups = qog.trust.region, labels = rownames(qog.trust), 
              ellipse = TRUE, circle = TRUE) +
  scale_color_discrete(name = '') +
  theme(legend.direction = 'vertical', legend.position = 'bottom')
g

###########################
# HCLUST, with ClustOfVar #
###########################

# The two-lines approach.
qog.tree <- hclustvar(qog.trust)
plot(qog.tree)

# with ggplot2, you need the standard hclust object from the distance matrix:
qog.hclust <- hclust(dist(qog.trust))

# get a dendogram function for ggplot2:
require(ggdendro)

# plot countries by similarity:
ggdendrogram(qog.hclust, theme_dendro=FALSE)
ggdendrogram(qog.hclust, rotate=TRUE, size=4, theme_dendro=FALSE, color="tomato")

# thanks to Gaston Sanchez for pointing out the package on his blog
# https://gastonsanchez.wordpress.com/2012/10/03/7-ways-to-plot-dendrograms-in-r/
