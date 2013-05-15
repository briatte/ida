

# Create a vector of 400 random values.
m <- runif(400)
# Print the first values of the vector.
head(m)
# Turn the vector into a 20 x 20 matrix. 
m <- matrix(m, nrow = 20)
# Check the class of the matrix object.
class(m)
# Name the matrix rows with letters.
rownames(m) <- letters[1:20]
# Plot the matrix as a heatmap.
heatmap(m)



setwd("~/Documents/Teaching/IDA")



# See the default packages.
getOption("defaultPackages")
# See where packages are stored.
.libPaths()



# Create a list of essential packages.
list <- c("foreach", "knitr", "devtools", "ggplot2", "downloader", "reshape")
# Select those that are not installed.
list <- list[!list %in% installed.packages()[, 1]]
# Install the missing packages.
if(length(list))
  lapply(list, install.packages, repos = "http://cran.us.r-project.org")



# Load ggplot2 package.
library(ggplot2)
# Load downloader package.
require(downloader)



# In case you have not yet installed ggplot2, this will.
if(!require(ggplot2)) {
  # Install the ggplot2 package.
  install.packages("ggplot2")
  # Load the ggplot2 package.
  library(ggplot2)  
}



# Look at first rows of a default dataset.
head(iris)



# Quick plot.
qplot(data = iris, x = Sepal.Length, y = Petal.Length)



# Select all lines below to run properly.
qplot(data = iris, 
      x = Sepal.Length, 
      y = Petal.Length, 
      color = Species, 
      size  = Petal.Width, 
      alpha = I(0.7))



# Function help.
?setwd
# Keyword search.
??heatmap
# Package docs.
help(package = "downloader")



median


