

"hello world"
1 + 2



# Create a text object, called 'x'.
x <- "Hello World!"
# Create a numeric object, called 'y'.
y <- (8^2)/5
# Combine both objects into a vector called 'z'.
z <- c(x, y)
# Print the vector object 'z' on screen.
print(z)
# More simply, just type its name and press Enter.
z



# See the default packages.
getOption("defaultPackages")
# See where packages are stored.
.libPaths()



# Create list of packages.
list <- c("foreach", "knitr", "devtools", "ggplot2", "httr", "RCurl", "reshape")
# Select those that are not installed.
list <- list[!list %in% installed.packages()[, 1]]
# Install packages. Select both lines to execute properly.
if(length(list))
  lapply(list, install.packages, repos = "http://cran.us.r-project.org")



# Load ggplot2 package.
library(ggplot2)
# Load RCurl package.
library(RCurl)


