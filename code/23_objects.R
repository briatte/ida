

## rm(list=ls());



# Download the data if needed.
if (!file.exists("data/grades.txt")) {
  # Install RCurl package. Remember that R is case-sensitive.
  install.packages("RCurl")
  # Load RCurl package.
  library(RCurl)
  # Locate the data.
  grades <- "https://raw.github.com/briatte/ida/master/data/grades.txt"
  # Download the data.
  grades <- getURL(grades)
  # Make the data readable.
  grades <- textConnection(grades)
}
# Load the data.
grades <- read.table("data/grades.txt", header = TRUE, )
# Check result.
head(grades)



# Install randomNames package. Remember that R is case-sensitive.
if(!"randomNames" %in% installed.packages()[,1])
  install.packages("randomNames")
# Load randomNames package.
library(randomNames)
# How many rows of data do we have?
nrow(grades)
# Let's generate that many random names.
names <- randomNames(86)
# Let's finally stick them to the matrix.
grades <- cbind(grades, names)
# Check result.
head(grades)



# Convert to data frame.
grades <- as.data.frame(grades)
# Check result.
head(grades)
# Check structure of a data frame.
str(grades)



# Install and load reshape package.
if(!"reshape" %in% installed.packages()[,1])
  install.packages("reshape")
library(reshape)
# Reshape data from 'wide' (lots of columns) to 'long' (lots of rows).
grades <- melt(grades, id.vars = "names")
# Check result.
head(grades)



# Install and load ggplot2 package.
if(!"ggplot2" %in% installed.packages()[,1])
  install.packages("ggplot2")
library(ggplot2)
# Plot all three exams.
qplot(data = grades, x = value, group = variable, geom = "density")
# Add color.
qplot(data = grades, x = value, color = variable, fill = variable, alpha = I(.3), geom = "density")



# Download the data if needed.
if (!file.exists("data/nhis.txt")) {
  # Load RCurl package.
  library(RCurl)
  # Locate the data.
  nhis <- "https://raw.github.com/briatte/ida/master/data/nhis.txt"
  # Download the data.
  nhis <- getURL(nhis)
  # Make the data readable.
  nhis <- textConnection(nhis)
}
# Load the data.
nhis <- read.table("data/nhis.txt", header = TRUE)
# Check result.
head(nhis)



# Compute BMI vectore.
bmi <- 703*nhis[ ,4]/nhis[ ,3]^2
# Bind to matrix.
nhis <- cbind(nhis, bmi)



# The plot.
qplot(data = nhis, x = bmi, geom = "density")



# Another plot. Variable x stands for gender.
qplot(data = nhis, x = bmi, geom = "density", group = x, color = factor(x))
# One more plot. Variable y stands for for racial group.
qplot(data = nhis, x = bmi, geom = "density", group = x, color = factor(x)) +
  facet_grid(y ~ .)


