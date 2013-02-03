

## setwd("~/Documents/Teaching/IDA")



# In case you have not yet installed ggplot2, this will.
if(!"ggplot2" %in% installed.packages()[,1])
  install.packages("ggplot2")
# Now load the ggplot2 package.
library(ggplot2)



# Look at first rows of a default dataset.
head(iris)



# Quick plot.
qplot(data = iris, x = Sepal.Length, y = Petal.Length)



qplot(data = iris, x = Sepal.Length, y = Petal.Length, color = Species, size = Petal.Width, alpha = I(0.7))


