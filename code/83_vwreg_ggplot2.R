# http://is-r.tumblr.com/post/32193893263/simple-visually-weighted-regression-plots
# A simple approach to visually-weighted regression plots

doInstall <- TRUE  # Change to FALSE if you don't want packages installed.
toInstall <- c("ggplot2", "reshape2", "MASS")
if(doInstall){install.packages(toInstall, repos = "http://cran.us.r-project.org")}
lapply(toInstall, library, character.only = TRUE)

# Generate some data:
nn <- 1000
myData <- data.frame(X = rnorm(nn),
                     Binary = sample(c(0, 1), nn, replace = T))
myData$Y <- with(myData, X * 2 + Binary * 10 + rnorm(nn, sd = 5))
myData$Y <- (myData$Y > 1) * 1
head(myData)

# Model:
myModel <- glm(Y ~ X + Binary, data = myData, family = "binomial")

# Generate predictions
nSims <- 1000
someScenarios <- expand.grid(1,  # Intercept
  seq(min(myData$X), max(myData$X), len = 100),  # A sequence covering the range of X values
  c(0, 1))  # The minimum and maximum of a binary variable, or some other first difference
  
simDraws <- mvrnorm(nSims, coef(myModel), vcov(myModel))
simYhats <- simDraws %*% t(someScenarios)
simYhats <- plogis(simYhats)

dim(simYhats)  # Simulated predictions

# Combine scenario definitions and predictions.
predictionFrame <- data.frame(someScenarios, t(simYhats))
# Reshape wide -> long:
longFrame <- melt(predictionFrame, id.vars = colnames(someScenarios))

head(longFrame)
zp1 <- ggplot(data = longFrame,
              aes(x = Var2, y = value, group = paste(variable, Var3), colour = factor(Var3)))
zp1 <- zp1 + geom_line(alpha = I(1/sqrt(nSims)))
zp1 <- zp1 + scale_x_continuous("X-axis label", expand = c(0, 0))
zp1 <- zp1 + scale_y_continuous("Y-axis label", limits = c(0, 1), expand = c(0, 0))
zp1 <- zp1 + scale_colour_brewer(palette="Set1", labels = c("Low", "High"))  # Change colour palette
zp1 <- zp1 + guides(colour = guide_legend("First-difference\nvariable",
                                          override.aes = list(alpha = 1)))  # Avoid an alpha-related legend problem
zp1 <- zp1 + ggtitle("Plot title")
zp1 <- zp1 + theme_bw()
print(zp1)  # This might take a few seconds...
