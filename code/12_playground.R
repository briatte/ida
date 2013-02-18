
## IDA Exercise 1.2
## ----------------


# Hello! This is yet another demo R script.

# Your mission is to run it like the first exercise, but this time from RStudio.
# Explore the interface of RStudio, and keep on practicing keyboard shortcuts.

# The script follows the same structure as the previous exercise. This one is
# more focused on the RStudio interface and on getting data ready for analysis.



# assign numeric value 9 to object x
x <- 9
# show x
x

# now assign a text value to object y
y <- "Hello World"
# show y
y

# combine both items into a vector
# notice how x becomes a piece of text (string)
c(x, y)
# save that combination
z <- c(x, y)
# check result
z

# replace object z with a sequence of integers
z <- 1:5
# show result
z
# copy it to object w
w <- z
# let's add the two vectors
w + z
# let's divide them by each other
w / z

# what kind of object is z?
mode(z)
# what class does it belong to?
class(z)
# is it a vector?
is.vector(z)
# can we calculate its mean?
mean(z)
# can we raise it to a power?
z^2
# what letters does it correspond to?
letters[z]
# what would it look like as a matrix?
as.matrix(z)
# what would it look like replicated four times?
rep(z, times = 4)
# or multiplied by random [0, 1] numbers?
z * runif(5)

# let's go graphic and plot z against w cubed
matplot(z, w^3, type = "l")
# your first plot! let's add a staircase line
matpoints(z, w^3, type = "s", col = "blue")

# delete object z
rm(z)
# can we get z now?
z
# delete everything from workspace
# note: don't go nuclear on your workspace without a good reason
rm(list = ls())

# we explain what happened in that script in the next sessions
# do not panic if most of it is obscure at that stage!

# Peace and doughnuts.
# 2013-02-14
