

4 %/% 3
6 %/% 3



# Create a random 3 x 5 matrix.
A <- matrix(as.integer(10*runif(30)), nrow = 3, ncol = 5)
# Check result.
A
# Create a random 2 x 2 (square) matrix.
B <- matrix(as.integer(10*runif(16)), nrow = 2, ncol = 2)
# Check result.
B
# Create another one.
C <- matrix(as.integer(10*runif(16)), nrow = 2, ncol = 2)
# Check result.
C
# Now a basic manipulation: scalar multiplication.
2*A
# Another one: extract the diagonal.
diag(B)
# Last one: matrix transposition.
t(C)



# Square matrix multiplication.
B %*% C



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


