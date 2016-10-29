## IDA Session 6
## -------------

packages <- c("gplots", "ggplot2", "Hmisc", "car", "gmodels")
packages <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})
qog <- read.csv("data/qog_basic_cs.csv")

# The list of variables is quasi-identical to the one used previously.
# Let's simply add an extra variable coding for geographical regions.
qog_b <- with(qog, data.frame(
  ccode  = ccodealp, # country three letter code
  cname  = cname,    # country name
  births = wdi_fr,   # fertility rate
  gdpc   = wdi_gdpc, # GDP per capita
  gexp   = wdi_ge,   # government expenditures as percentage of GDP
  hexpc  = wdi_hec,  # health care expenditure per capita
  gini   = uw_gini,  # GINI coefficient of inequality 
  edu    = bl_asyt25,# average years of schooling
  gris   = wdi_gris, # female to male ratio in schools
  winpar = m_wominpar, # percentage of women in parliament
  region = ht_region # region of country
))

# Clean up missing data.
qog_b <- na.omit(qog_b)
# Clean up row names.
rownames(qog_b) <- NULL
# Reorder country factor levels by their respective fertility rates.
qog_b$cname <- with(qog_b, reorder(cname, births))


# Recodings
# ---------

#Let's give value labels to the region var
qog_b$region<-factor(qog_b$region, levels=c(1,2,3,4,5,6,7,8,9,10), labels=c("EEur","LatAm","NAfr&MEast","SubSAfr","WEur&NAm","EAsia","SEAsia","SAsia","Pacif","Carib"))

#Let's recode some vars into categorical variables
#This will be useful for presenting some of the stats and graphs from this session
#Recode all continuous vars into two equally sized categories for low and high levels
qog_b$births2<-(cut(qog_b$births, breaks=quantile(qog_b$births,probs=seq(0,1, by=.5)), labels=c("l","h"), ordered=T, include.lowest=T))
qog_b$gdpc2<-(cut(qog_b$gdpc, breaks=quantile(qog_b$gdpc,probs=seq(0,1, by=.5)), labels=c("l","h"), ordered=T, include.lowest=T))
qog_b$gexp2<-(cut(qog_b$gexp, breaks=quantile(qog_b$gexp,probs=seq(0,1, by=.5)), labels=c("l","h"), ordered=T, include.lowest=T))
qog_b$hexpc2<-(cut(qog_b$hexpc, breaks=quantile(qog_b$hexpc,probs=seq(0,1, by=.5)), labels=c("l","h"), ordered=T, include.lowest=T))
qog_b$gini2<-(cut(qog_b$gini, breaks=quantile(qog_b$gini,probs=seq(0,1, by=.5)), labels=c("l","h"), ordered=T, include.lowest=T))
qog_b$edu2<-(cut(qog_b$edu, breaks=quantile(qog_b$edu,probs=seq(0,1, by=.5)), labels=c("l","h"), ordered=T, include.lowest=T))
qog_b$gris2<-(cut(qog_b$gris, breaks=quantile(qog_b$gris,probs=seq(0,1, by=.5)), labels=c("l","h"), ordered=T, include.lowest=T))
qog_b$winpar2<-(cut(qog_b$winpar, breaks=quantile(qog_b$winpar,probs=seq(0,1, by=.5)), labels=c("l","h"), ordered=T, include.lowest=T))

#Finally, let's tell R to look in the qog_b subset for any variable we mention subsequently
#The command saves us time and frees us from the need to type "qog_b$" in front of every variable call
#Note that the command is canceled as follows: detach(qog_b)
attach(qog_b)

#DESCRIPTIVE UNIVARIATE STATS
#Basic commands for continuous (and ordinal) measures
describe(qog_b)
summary(qog_b)
#You can obtain specific stats with the following commands
max(births)
min(births)
mean(births)
median(births)
sd(births)
quantile(births)
quantile(births, probs=c(0.1, 0.9)) #for specific cut points

#Basic commands for categorical (and ordinal) measures
table(region) #frequencies by category
prop.table(table(region)) #in proportions
round(prop.table(table(region)), 2) #rounds to two decimals points
round(100*(prop.table(table(region)))) #in %

#GRAPHICS OF DISTRIBUTIONS
#For continuous vars
hist(births, main="Historgram of Fertility in 81 countries")
hist(births, br=20)
stripchart(births, method="jitter", main="Stripchart with Jitter")
boxplot(births, main="Boxplot of Fertility in 81 countries")
qqnorm(births)
qqline(births)
#For categorical vars
barplot(table(region))
barplot(table(region), horiz=T)
dotchart(table(region), cex=1)
pie(table(region))

#DESCRIPTIVE BIVARIATE STATS
#For a pair of categorical vars
table(region, births2) #frequencies
round(100*(prop.table(table(region, births2))),2) #in total %
round(100*(prop.table(table(region, births2),1)),2) #in row %
round(100*(prop.table(table(region, births2),2)),2) #in column %

#GRAPHICS OF BIVARIATE ASSOCIATIONS
#For a pair of categorical vars
mosaicplot(table(region, births2), col=T)
mosaicplot(table(gini2, births2), col=T)
#For a continuous and a categorical vars
boxplot(births~region)
qplot(region, births, geom=c("boxplot","point"))
boxplot(births~gini2)
qplot(gini2, births, geom=c("boxplot","point"))
qplot(region, births, geom="boxplot", fill=gini2)

#ASSOCIATION TESTS
#Test of independence of a pair of categorical variables
chisq.test(table(region, births2)) #chi-squared test of independence
fisher.test(table(region, births2)) #for vars with categories<5 observations, this test is more appropriate
chisq.test(table(gini2, births2))
chisq.test(table(gdpc2, births2))
chisq.test(table(gexp2, births2)) #etc.

#Test of independence of a binary and a continuous variables
t.test(births~gini2)
t.test(births~gdpc2)
t.test(births~gexp2) #etc.

#CONFIDENCE INTERVALS
t.test(births)
#The barplots below don't work for region b/c there are categories with too few cases to estimate the conf. intervals
b_gini_mean<-tapply(births, gini2, mean)
lower<-tapply(births, gini2, function(v) t.test(v)$conf.int[1])
upper<-tapply(births, gini2, function(v) t.test(v)$conf.int[2])
barplot2(b_gini_mean, plot.ci=T, ci.l=lower, ci.u=upper)

b_gdpc_mean<-tapply(births, gdpc2, mean)
lower<-tapply(births, gdpc2, function(v) t.test(v)$conf.int[1])
upper<-tapply(births, gdpc2, function(v) t.test(v)$conf.int[2])
barplot2(b_gdpc_mean, plot.ci=T, ci.l=lower, ci.u=upper)

b_gexp_mean<-tapply(births, gexp2, mean)
lower<-tapply(births, gexp2, function(v) t.test(v)$conf.int[1])
upper<-tapply(births, gexp2, function(v) t.test(v)$conf.int[2])
barplot2(b_gexp_mean, plot.ci=T, ci.l=lower, ci.u=upper)

b_gris_mean<-tapply(births, gris2, mean)
lower<-tapply(births, gris2, function(v) t.test(v)$conf.int[1])
upper<-tapply(births, gris2, function(v) t.test(v)$conf.int[2])
barplot2(b_gris_mean, plot.ci=T, ci.l=lower, ci.u=upper)

b_winpar_mean<-tapply(births, winpar2, mean)
lower<-tapply(births, winpar2, function(v) t.test(v)$conf.int[1])
upper<-tapply(births, winpar2, function(v) t.test(v)$conf.int[2])
barplot2(b_winpar_mean, plot.ci=T, ci.l=lower, ci.u=upper)