

# List workspace objects.
ls()
# Erase entire workspace.
rm(list = ls())



# Install downloader package.
if(!"downloader" %in% installed.packages()[, 1])
  install.packages("downloader")
# Load package.
require(downloader)
# Target file.
file = "data/grades.2012.csv"
# Download the data if needed.
if (!file.exists(file)) {
  # Locate the data.
  url = "https://raw.github.com/briatte/ida/master/data/grades.2012.csv"
  # Download the data.
  download(url, file, mode = "wb")
}
# Load the data.
grades <- read.table(file, header = TRUE)
# Check result.
head(grades)



# Install randomNames package. Remember that R is case-sensitive.
if(!"randomNames" %in% installed.packages()[, 1])
  install.packages("randomNames")
# Load package.
require(randomNames)
# How many rows of data do we have?
(count = nrow(grades))
# Let's generate that many random names.
names <- randomNames(count)
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
if(!"reshape" %in% installed.packages()[, 1])
  install.packages("reshape")
# Load package.
require(reshape)
# Reshape data from 'wide' (lots of columns) to 'long' (lots of rows).
grades <- melt(grades, id.vars = "names")
# Check result to show how each grade is now held on a separate row.
head(grades[order(grades$names), ])



# Install and load ggplot2 package.
if(!"ggplot2" %in% installed.packages()[, 1])
  install.packages("ggplot2")
# Load package.
require(ggplot2)
# Plot all three exams.
qplot(data = grades, x = value, 
      group = variable, 
      geom = "density")
# Add color and transparency.
qplot(data = grades, x = value, 
      color = variable, 
      fill = variable, 
      alpha = I(.3), geom = "density")



file = "data/nhis.2005.csv"
# Download the data if needed.
if (!file.exists(file)) {
  # Locate the data.
  url = "https://raw.github.com/briatte/ida/master/data/nhis.2005.csv"
  # Download the data.
  download(url, file, mode = "wb")
}
# Load the data.
nhis <- read.table(file, header = TRUE)
# Check result.
head(nhis)



# Compute BMI vectore.
bmi <- 703 * nhis[ ,4] / nhis[ ,3]^2
# Bind to matrix.
nhis <- cbind(nhis, bmi)



# The plot.
qplot(data = nhis, x = bmi, geom = "density")



# Another plot. Variable x stands for gender.
qplot(data = nhis, x = bmi, group = x, color = factor(x), geom = "density")
# One more plot. Variable y stands for for racial group.
qplot(data = nhis, x = bmi, group = x, color = factor(x), geom = "density") +
  facet_grid(y ~ .)


