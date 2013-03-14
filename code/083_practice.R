

source("code/8_imf.R")



imf.plot



summary(imf.lm)



imf.plot + geom_smooth(method = "lm", fill = "steelblue", alpha = .2) +
  geom_segment(x = imf$D_struct_bal, xend = imf$D_struct_bal, 
               y = imf$D_growth, yend = fitted.values(imf.lm),
               linetype = "dashed", color = "red")



imf.rvfplot + geom_point(aes(color = rdist), size = 18, alpha = .3) + 
  scale_colour_gradient2(name = "Residual\ndistance", 
                         low = "green", mid = "orange", high = "red",
                         midpoint = mean(imf.rvf$rdist))



imf.rvfplot + aes(y = rsta) + labs(y = "Standardized residuals") +
  geom_hline(y = c(-2, 2), linetype = "dotted") + 
  geom_point(data = subset(imf.rvf, outlier1 == TRUE), 
             color = "red", size = 18, alpha = .4)


