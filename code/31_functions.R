

# Create a vector of 99 random [0,1] values.
x <- runif(9)
# Check result: show first 5 values.
head(x)
# Add them up.
sum(x)



# Define function
add <- function(x,y) {
  x + y
}
# Example.
sum(2,4)



# Calculate a factorial
# Input: a number (n)
# Output: the factorial of n
# Presumes: n is a single positive integer
my.factorial <- function(n) {
  if (n == 1) {  # Base case
    return(1)
  } else {  # Recursion
    return(n*my.factorial(n-1))
  }
}



qplot(c(0,2), stat="function", fun=identity, geom="point")



qplot(c(-10,10), stat="function", fun=sin, geom="line")



qplot(c(-10:10), stat="function", fun=exp, geom=c("line","point"))


