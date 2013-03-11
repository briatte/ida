
## IDA Exercise 1
## --------------


# Hello! This is a demo R script. You should be reading it inside RStudio after
# reading the course pages from Session 1. Read these pages now if you haven't.

# We'll start with a few simple things about the RStudio interface. The most
# important trick follows: When possible, Always. Use. Keyboard. Shortcuts.


# RStudio interface basics
# ------------------------

# This line is a comment. It is meant for humans like you to read with the code.
# RStudio shows comments in a different color than R code to help you see them.

# In RStudio, scripts open in the top-left pane by default. Panes can be resized
# or minimized/maximized by clicking their borders or their top-right icons.

# Syntax coloring, panes and many other things can be adjusted in the RStudio
# preferences. Select the "Tools" menu and then select "Options…" to get there.

# There is one setting that you want to change right now -- that's the default
# working directory. For this course, set it permanently to the "IDA" folder.

# The script shows a few very basic operations with R. Train yourself to "run"
# (execute) them in in RStudio. To run a given line of code, proceed as follows:

# 1- If needed, press Ctrl-1 to move the cursor to the script's window.
#    This window is called the Source Editor in RStudio.

# 2- Move your cursor to a given line using the keyboard arrows.
# 3- Press Cmd-Enter (Mac) or Ctrl-Enter (Win) to run the line.

# Put your cursor anywhere on the next line and run from the keyboard:
message("Hello R World!")

# Now look at your Console (bottom-left quadrant by default in RStudio).
# If you see a "Hello World!" message in red ink, it worked: well done!

# You might have noticed that running a command moves your cursor to the next
# line, which helps running things sequentially. Neat trick, RStudio.

# Your mission is to run this whole script while reading the comments along.
# First, a few tips on running code from a command line interface (CLI).


## Command line tricks
## -------------------

# You can select several lines together. This is sometimes required to run loops
# or functions. You will see { curly brackets } in this case. To do that:

# 1- Move your cursor anywhere on the first line that you want to run.
# 2- Press Cmd-LeftArrow (Mac) or Home (Win) to reach the beginning of the line.
# 3- Select the next ones with Shift + DownArrow until the ending bracket.
# 4- Press Cmd-Enter (Mac) or Ctrl-Enter (Win) to run.

# Try to run that code block to define a useless "Hello World" function.
hello.world <- function(x) {
  rep("Hello R World!", x)
}

# You should not see any result yet, but a function is now in your Workspace.
# In RStudio, the workspace is shown by default in the top-right quadrant.

# Now run the next line, which will work only if the previous operation has.
hello.world(99)

# Congratulations, you just filled your Console with useless output!
# Clean your Console with Ctrl-L (Mac/Win).

# Yet another trick: you can run a whole function by moving your cursor anywhere
# in it, and then press Cmd-Alt-F (Mac) or Ctrl-Alt-F (Win). Another neat trick.

# Important: get used to working with keyboard arrows and shortcuts RIGHT NOW!
# It will save you enormous amounts of time from copy-pasting and all that.

# One more trick: what if you get lost in class, or if things just stop working?
# Do not panic, and do this instead:

# 1- Put your mouse on an empty line near where you are.
# 2- Press Cmd-Shift-UpArrow (Mac) or Ctrl-Shift-Home (Win).
# 3 - This selects all code from the start. Run it all.

# The whole script will execute again from the top, solving any problem that
# you might have encountered. This works only if the code has not been damaged.

# You can run that trick with a shortcut: Cmd-Alt-B (Mac) or Ctrl-Alt-B (Win).
# So really, get to learn keyboard shortcuts, it will save you lots of trouble.


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
# Vectors can be created by using the c() function to combine objects.

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

# Build a sequence of integers.
seq(1, 3, by = 1)
# You can write that in much shorter form.
1:3
# Multiply all items of that sequence by 2.
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
v[-c(1:10)]

# What happened here is: (1) show me vector v, (2) but only [some elements];
# (3) -skip some elements (minus sign); (4) those elements are 1, 2, ... 10.


## Help pages
## ----------

# To finish, go crazy.
rep(y, times = x^2)

# What happened here? View the help page for function rep().
# In RStudio, help opens in the bottom-right quadrant by default.
?rep

# What happened is that you asked to repeate object y ("Hello World!"), x times.
# Since object x is equal to the numeric value 9, y got repeated 9^2 = 81 times.
rep("Alright, this is how it works!", times = 9)

# Note that this is the same function that you trained yourself on earlier on.
# The syntax is slightly different, because you wrote "times" explicitly here.
rep("So... How do I learn about function syntax?", 9)

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
exists("x")

# Remove all objects from the Workspace.
rm(list = ls())

# All objects have been deleted and are now undefined.
exists("y")

# Now load your saved Workspace again.
load("hello.Rda")

# All objects are now back in memory.
ls()


## Disk files
## ----------

# The rm() command works only in your Workspace. It does not remove disk files.
# To manipulate disk files, you need to use the "file" functions (with caution).

# Verify whether file "hello.Rda" exists.
file.exists("hello.Rda")
# Rename it to something perhaps more explicit.
file.rename("hello.Rda", "Exercise-1.Rda")
# Remove the file completely.
file.remove("Exercise-1.Rda")

# Caution: files deleted with file.remove() are NOT recoverable!
# Learn more about disk file manipulation from R. Use with care.
?files


## Quitting R
## ----------

# When you will quit, R will ask if you want to first save your Workspace into
# an invisible file called ".Rdata" in your working directory. Answer "Yes".

# Which directory is currently your working directory?
getwd()

# And what is that, again? (A: Read the course pages!)
?getwd

# We will always work from the IDA working directory. When you run R scripts for
# this course in or outside class, always make it your working directory first.

# Quit now. You might want to save this script if you have added notes to it.
# Quit as you would quit any other application or let R do it as shown below.

# Uncomment the next line by removing the frontal hash symbol and then run it.
# q()


## Enjoy your day.
## 2013-02-27
