

source("code/8_imf.R")
imf.plot



# Checking on the model.
summary(imf.lm)
# Checking on the coefficient.
coef(imf.lm)[2]



imf.plot + geom_smooth(method = "lm")



imf.rvfplot + geom_point(aes(color = rdist), size = 18, alpha = .3) + 
  scale_colour_gradient2(name = "Residual\ndistance", 
                         low = "green", mid = "orange", high = "red",
                         midpoint = mean(imf.rvf$rdist))



imf.rvfplot + aes(y = rsta) + labs(y = "Standardized residuals") +
  geom_hline(y = c(-2, 2), linetype = "dotted") + 
  geom_point(data = subset(imf.rvf, outlier1 == TRUE), 
             color = "red", size = 18, alpha = .4)


