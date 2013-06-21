
## IDA Exercise 5
## --------------


# This exercise replicates PCA plots using World Values Survey data on
# aggregate confidence in public institutions.

# The data is taken from the Quality of Government dataset. The functions
# contain a mix of base functions and custom packages.


# Packages
# --------

# Load/install packages.
packages <- c("ape", "ClustOfVar", "cluster", "countrycode", "devtools", "FactoMineR", "foreign", "ggdendro", "ggplot2", "reshape")
packages <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})

# install ggbiplot
if(!"ggbiplot" %in% installed.packages()[, 1]) install_github("ggbiplot", "vqv")
require(ggbiplot)


# Worldwide fertility
# -------------------

# downloaded during last session:
qog.data <- read.csv("data/qog.cs.txt", stringsAsFactors = FALSE)

# drop duplicate observation:
qog.data = subset(qog.data, cname != "Congo, Democratic Republic")

# subset:
qog <- with(qog.data, data.frame(
  fertility.rate  = wdi_fr,    # fertility rate
  gdp.per.capita  = wdi_gdpc,  # GDP per capita
  gov.expenditure = wdi_ge,    # government expenditures as % of GDP
  healthcare.exp  = wdi_hec,   # health expenditure per capita
  gini.inequality = wdi_gini,  # Gini coefficient of inequality
  female.school.years = bl_asy25f, # average female years of schooling
  female.school.ratio = wdi_gris,  # female to male ratio in schools
  women.in.parliament = gid_wip    # % of women in parliament
  ))

# row names:
rownames(qog) = gsub("\\(.*", "", qog.data$cname)

# inspect:
head(qog)

# sample reduction:
qog <- na.omit(qog)


# Heatmap
# -------

# 1. refactor
qog_hm = data.frame(qog, cname = row.names(qog))
qog_hm$cname = with(qog_hm, reorder(cname, fertility.rate))

# 2. melt
qog_hm <- melt(qog_hm)
qog_hm <- ddply(qog_hm, .(variable), transform, rescale = scale(value))

# 3. plot
p <- ggplot(qog_hm, aes(variable, cname)) +
  geom_tile(aes(fill = rescale), colour="white") +
  scale_fill_gradient(low = "white", high = "steelblue")

# 4. theme
p + theme_grey(base_size = 12) + 
  labs(x = NULL, y = NULL) + 
  scale_x_discrete(expand = c(0, 0)) + 
  scale_y_discrete(expand = c(0, 0)) + 
  theme(legend.position = "none",
        axis.text.x = element_text(size = 16, angle = 60, hjust = 1, colour = "grey50"))


# Principal components
# --------------------

fit <- princomp(qog, cor=TRUE)

# screeplot:
plot(fit, type = "l")

# loadings:
loadings(fit)

# biplot:
biplot(fit)


# Hierarchical Clustering
# -----------------------

# create Ward distance matrix
d <- dist(qog, method = "euclidean")
h <- hclust(d, method = "ward")

# dendogram:
plot(h)

# cut 5 clusters:
clus5 = cutree(h, 5)

# plot with red borders:
rect.hclust(h, k = 5, border = "red")

# phylogenic plots with ape:
h.phylo = as.phylo(h)
h.color = c("#556270", "#4ECDC4", "#1B676B", "#FF6B6B", "#C44D58")[clus5]

# basic fan plot:
plot(h.phylo, type = "fan", tip.color = h.color, label.offset = 1)

# size of labels set to (log) fertility rate:
plot(h.phylo, type = "fan", tip.color = h.color, label.offset = 1,
     cex = log(qog$fertility.rate, 2.5))


# k-means
# -------

# k-means for 5 clusters:
k <- kmeans(qog, 5)

# describe the matrix
k

# plot with the cluster package
clusplot(qog, k$cluster, color = TRUE, shade = TRUE, labels = 2, lines = 0)


# k-means with ggplot2:
# ---------------------

# 2-dimensional subset:
k = qog[, c("fertility.rate", "female.school.years")]

# k-means:
k = kmeans(k, 3)

# extract centers:
centers = data.frame(k$centers)

# stick clusters to data:
qog$cluster = factor(k$cluster)

# reintroduce country codes:
qog$iso3c = countrycode(row.names(qog), "country.name", "iso3c")

# plot with ggplot2:
ggplot(data = qog, aes(y = fertility.rate, x = female.school.years, color = cluster)) + 
  geom_text(aes(label = iso3c)) +
  geom_point(data = centers, 
             aes(color = 'Center'), 
             size = 52, 
             alpha = .3, 
             show_guide = FALSE)


# Confidence in public institutions
# ---------------------------------

# Quality of Government, Stata version.
# Cheers to the OQG team and to the Swedish taxpayer.
qog <- read.dta("data/qog.cs.dta")

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
qog <- qog[, !names(qog) %in% c("European Union", "NATO")]

# Subset to nonmissing data.
qog <- na.omit(qog)

# Finalized dataset.
str(qog)

# Countries considered.
rownames(qog)

# Extract regions.
table(countrycode(rownames(qog), "iso3c", "region"))


# PCA with FactoMineR
# -------------------

# The two-lines approach.
qog.PCA <- PCA(qog, graph = FALSE)
plot(qog.PCA)

# with ggplot, you need the standard prcomp object:
qog.prcomp <- prcomp(qog, scale = TRUE)

# ggbiplot
ggbiplot(qog.prcomp,
         labels = rownames(qog),
         groups = countrycode(rownames(qog), "iso3c", "continent"),
         ellipse = TRUE) + 
  coord_equal(xlim = c(-3, 3), ylim = c(-3, 3))


# Hierarchical clustering with ClustOfVar
# ---------------------------------------

# The two-lines approach.
qog.tree <- hclustvar(qog)
plot(qog.tree)

# ggplot2 requires the standard hclust object:
qog.hclust <- hclust(dist(qog))

# plot countries by similarity with ggdendro:
ggdendrogram(qog.hclust, rotate = TRUE, size=4)


# We'll let you build your examples in groups for the first class exercise.
# 2013-06-21
