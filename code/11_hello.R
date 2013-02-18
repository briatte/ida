
## IDA Exercise 1.1
## ----------------


# Hello! This is a demo R script.
# This line is a comment. It does not produce any result.

# The script shows a few basic operations with R.
# Train yourself to "run" (execute) them in R or RStudio:

# 1 - Select a whole line from the keyboard.
# 2 - Press Cmd-Enter (Mac) or Ctrl-Enter (Win) to run.

# You can select several lines together by pressing Shift + arrows.
# Get used to working with keyboard shortcuts RIGHT NOW!

# Your mission is to run this whole script while reading the comments.
# Let's start with the absolutely essential "Hello World" routine.


## Data objects
## ------------

# Assign text value to object y. The quotes are essential here.
y <- "Hello World!"
# Show object y. This will work only if you ran the previous line.
y

# Disregard the "[1]" in the margin for now.
# Let's create a different object.

# Assign numeric value 9 to object x.
x <- 9
# Show object x. There are no quotes because the result is numeric, not text.
x

# Both objects x and y contain only one value. We say they are "of length 1".
# However, x and y cannot be added together: they are of different kinds.


## R functions
## -----------

# The previous commands created objects that contain some data.
# These objects are of a particular class.

# Object x is a number.
class(x)
# Object y is a string of characters (i.e. a piece of text).
class(y)

# The class of an object is available through the class() function.
# That's the very basic terminology of R. We also call functions "commands".

# Verify that x is numeric. The result is a logical value.
is.numeric(x)
# Verify that y is character (text). The result is also a logical value.
is.character(y)

# Now a slight variation: change the number x into its text equivalent.
as.character(x)
# You cannot do the same thing with y: characters cannot become numbers.
as.numeric(y)

# The "NA" symbol in the output of the last command is a missing value.
# Let's now have a bit of fun with some other special cases of values.


## R mathematics
## -------------

# R works like a scientific calculator.
2 + 2^2
# The caret sign (^) is for powers. A root is just a fractional power.
9^(1/2)
# The example above is a square root. The example below is a cubic root.
27^(1/3)

# R contains a large array of "primitive functions", like the natural exponent.
exp(1)

# Do you remember exponents? Their progression is quicker than powers.

# A power is when f(x) = x^k.
3^2
4^2
5^2
# An exponent is when f(x) = k^x.
2^3
2^4
2^5

# Do you remember logarithms? They're the reverse function of exponents.

# Take the natural logarithm of Euler's constant.
log(exp(1))

# Take the logarithm of base 10 for 10^3.
log10(10^3)

# Let's create an object by dividing by zero.
z <- 1/0
# What is its value?
z

# "Inf" means "positive infinity".
# Let's get playful.

# Add 1 to positive infinity.
Inf + 1
# Negative infinity.
Inf * -1
# Infinity divided by itself.
Inf / Inf

# "NaN" means "Not a Number". There are several particular special values in R.

# Define object u as an empty set. 
u <- NULL
# Object a now contains nothing.
u
# Its class is "NULL".
is.null(u)

# "NULL" is different from "NA", which means "missing" rather than "empty".
# A NULL object is also different from an inexistent i.e. undefined object.

# Object u is NULL but it does exist.
exists("u")
# Object q is inexistent (undefined).
exists("q")


## Vectors
## -------

# A particularly useful kind of object is the vector.
# Vectors can be created by using the c() command to combine objects.

# Here's a vector made of three integers.
s <- c(2, 4, 6)
# The vector has a length of 3.
length(s)
# The mean of the vector is the mean of its elements.
mean(s)
# Check whether object s is vector.
is.vector(s)

# All elements of a vector have to be of the same class.
# R will convert elements to make sure this happens.

# Try combining the numeric object x with text object y.
w <- c(x, y)
# Check result: numeric object x has been converted to a character.
w

# Let's go back to vector s, which was defined as the sequence { 2, 4, 6 }.
# This vector is simply the sequence n = { 1, 2, 3 }, multiplied by 2.

# Build a sequence of integers in R.
seq(1:3)
# You can write that in shorter form.
1:3
# Now mutiply all sequence items by 2.
2 * 1:3

# Let's create the longer sequence f(x) = x^2 for x = { 1, 2, ..., 100 }.
v <- (1:100)^2
# Show result.
v
# How long is vector v? You guessed it: as long as the integer sequence 1:100.
length(v)

# The margin numbers indicate the position of each element in the vector.
# You can access elements by their position number.

# Select the first element of vector v.
v[1]
# Select the first three elements of v.
v[1:3]
# Select the last element of v.
v[length(v)]
# Select all elements of v at the exception of the first 10.
v[-seq(1:10)]

# What happened here is: (1) show me vector v; (2) but only some of elements;
# (3) remove some elements (minus sign); (4) those elements are 1, 2, ... 10.


## Help pages
## ----------

# To finish, go crazy.
rep(y, times = x^2)

# What happened here? View the help page for function rep().
?rep

# The help page for rep() reads rather well, and there are examples at the end.
# You can actually access the examples directly.
example(rep)

# Take advantage of handbooks: find rep() in the index of Teetor's "R Cookbook".
# It's at page 33 in Section 2.7, with more examples of how sequences work in R.

# This exercise is almost finished. We have created a lot of objects: x, y, etc.
# These objects were stored into the Workspace. Use ls() to list your Workspace.
ls()

# Learn about the ls() command.
?ls

# The ls() command is covered in Section 2.3 of Teetor's handbook. Chapter 2 of 
# Teetor is part of the readings for next week, as listed on the course index.

# Learn about other help pages.
?help.search

# Try one of the examples shown at the bottom of the help page.
help.search("linear models")

# Here's a shorter way to execute the same search.
??"linear models"

# R documentation is difficult to read because of the excess (lack) of detail.
# Read the top of help pages and try out any simple examples shown at the end.

# As said above, take advantage of your handbooks. The readings for this week
# are Kabacoff's Chapter 1 and Teetor's Chapters 1 and 3. Read and practice.


## Workspace commands
## ------------------

# Save the whole Workspace to a R data file.
save.image("hello.Rda")

# Learn about the save() and save.image() commands.
?save

# Remove object x from the Workspace.
rm(x)

# Object x is now undefined.
x

# Remove all objects from the Workspace.
rm(list = ls())

# All objects have been deleted and are now undefined.
y

# Now load your saved Workspace again.
load("hello.Rda")

# All objects are now back in memory.
ls()


## Disk files
## ----------

# The rm() command works only in your Workspace. It does not remove disk files.

# Verify whether file "hello.Rda" exists.
file.exists("hello.Rda")
# Rename it to something more explicit.
file.rename("hello.Rda", "Exercise11.Rda")
# Remove the file completely.
file.remove("Exercise11.Rda")

# Caution: files deleted with file.remove() are NOT recoverable!
# Learn more about disk file manipulation from R. Use with care.
?files


## Quitting R
## ----------

# When you will quit, R will ask if you want to first save your Workspace into
# an invisible file called ".Rdata" in your working directory. Answer "No".

# Which directory is currently your working directory?
getwd()

# And what is it, by the way?
?getwd

# We will come back to the working directory and everything else shown in this
# script after we install RStudio and continue working with R from there.

# Quit now. You might want to save this script if you have not yet done so.
q()


## Enjoy your day.
## 2013-02-13
