# From Exercise 2.1:

# Quételet's original Body Mass Index function.
# Requires weight in kilograms and height in meters.
bmi.quetelet <- function(weight, height, digits = 2) {
  round(weight / (height^2), digits)
}

# Check if it works.
bmi.quetelet(65, 1.8)
bmi.quetelet(35, 1.8)
bmi.quetelet(95, 1.8)

# Now:

# ... so you like math?
# ... you like logic too?
# ... let's be playful.

# Create a BMI classification scale.
bmi.scale <- c(0, 18.5, 25, 30, 40)
# We need the names to go with it.
bmi.class <- c("Underweight", "Normal", "Overweight", "Obese", "Mordibly obese")

# Check both elements have the same length.
length(bmi.scale) == length(bmi.class)

# Remember what a modulo is? "How many times can you fit y into x"?
# R has a quick syntax for it.
4 %/% 3
# ... because 4/3 = 1 plus something smaller than 1.
# The remainder is just one little modification away.
4 %% 3
# You can fit 3 five times into 17...
17 %/% 3
# ... and 17 - 3 * 5 = 2.
17 %% 3

# Now try to get the modulo of an imaginary BMI value that is underweight.
15 %/% bmi.scale
# That's correct: 15 / 0 = positive infinity.
15 / 0

# Now try to get the remainder of an imaginary BMI value that is overweight.
27 %% bmi.scale
# That's correct: the remainder of 27 / 0 is not a number (NaN).
27 %% 0

# Let's save the result of this last operation.
x <- 27 %% bmi.scale
# Check result.
x
# Identify the values where the remainder is NOT equal to the imaginary BMI.
x != 27
# Save it to an object.
y <- (x != 27)
# Remove the FALSE values: keep only the vector elements that are not FALSE.
y <- y[y != FALSE]
# Check result.
y
# The length of the resulting object is the category to which the BMI belongs.
bmi.class[length(y)]

# ... Notice how R fails gracefully by keeping the first NA element.
# ... But anyway, I digress. This whole stuff is not very efficient.
# ... All that work just to fit a number within a range!

# Note the simple/lazy solution:
fake.bmi <- 32
if(fake.bmi < 18.5) fake.class = "Underweight"
if(fake.bmi >= 18.5 & fake.bmi < 25) fake.class = "Normal"
if(fake.bmi >= 25 & fake.bmi < 30) fake.class = "Overweight"
if(fake.bmi >= 30 & fake.bmi < 40) fake.class = "Obese"
if(fake.bmi >= 40) fake.class = "Mordibly obese"

# ... but this is too long to code, and we are too lazy.

# Back to logic.
27 < bmi.scale
# Save it.
z <- (27 > bmi.scale)
# Check.
z
# Remove FALSE values.
z <- z[z != TRUE]
# Check.
z
# Length.
z <- length(z)
# Check.
z
# BMI classification.
bmi.class[z]
# This is almost as short as we would like.

# By the power of R, we can code all of that into one line.
bmi.class[length(bmi.scale[27 > bmi.scale])]

# Code that as a function.
bmi.quetelet <- function(weight, height, digits = 2) {
  bmi <- weight / (height^2)
  bmi.scale <- c(0, 18.5, 25, 30, 40)
  bmi.class <- c("Underweight", "Normal", "Overweight", "Obese", "Mordibly obese")
  class <- bmi.class[length(bmi.scale[bmi > bmi.scale])]
  # Save results as a vector. Note how we round the BMI only at "print stage".
  r <- c(round(bmi, digits), class)
  # Return BMI and classification.
  return(r)
}

# Examples.
bmi.quetelet(35, 1.80)
bmi.quetelet(65, 1.80)
bmi.quetelet(95, 1.80)
bmi.quetelet(99, 1.80)
bmi.quetelet(99, 1.50)

# Still here? Your math teacher would be proud of you.
# This is just the beginning.
