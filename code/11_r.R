

"hello world"
1 + 2



# Create a text object, called 'txt'.
a <- "Hello World!"
# Create a numeric object, called 'num'.
b <- (8^2)/5
# Apply a function to store the date.
c <- date()
# Combine both objects into a vector, called 'msg'.
message <- c(a, b, c)
# Print the vector object 'msg' on screen.
print(message)
# More simply, just type its name and press Enter.
message



# The default packages.
getOption("defaultPackages")



# Create list of packages. 
list <- c("foreach", "knitr", "devtools", "ggplot2", "RCurl")
# Select those that are not installed.
list <- list[!list %in% installed.packages()[, 1]]
# Install packages.
install.packages(list, repos = "http://cran.us.r-project.org")



# Load ggplot2 package.
library(ggplot2)
# Load RCurl package.
library(RCurl)


