

packages <- c("ggplot2", "reshape", "ape", "Hmisc", "cluster")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Load the dataset.
qog <- read.csv("data/qog_basic_cs.csv")
# Extract and rename.
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
  winpar = m_wominpar# percentage of women in parliament
  ))
# Check result.
head(qog_b)



# Subset to nonmissing data: 'NA' means 'not available' in this context.
qog_b <- na.omit(qog_b)
# Delete unused row names.
rownames(qog_b) <- NULL
# Order country levels by fertility rate.
qog_b$cname <- with(qog_b, reorder(cname, births))




# Explore variables with simple summary statistics
describe(qog_b)



# Save for later use.
save(qog_b, file = "data/qog_b.Rda")



# Reshape, letting the function guess the unique row identifiers.
qog_hm <- melt(qog_b)
# Rescale.
qog_hm <- ddply(qog_hm, .(variable), transform, rescale = scale(value))



# Compose plot.
p <- ggplot(qog_hm, aes(y = cname, x = variable)) + 
  geom_tile(aes(fill = rescale), colour = "white") +
  scale_fill_gradient("Scale", low = "white", high = "steelblue", 
                      guide = guide_legend(keywidth = 3, keyheight = 3)) + 
  scale_x_discrete(expand = c(0, 0)) + 
  scale_y_discrete(expand = c(0, 0)) +
  labs(x = NULL, y = NULL)
# View result with larger font.
p + theme_grey(base_size = 24)


