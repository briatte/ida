
## IDA Exercise 2.2
## ----------------


# Welcome back.

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


# All your base are belong to us.
# 2013-02-14
