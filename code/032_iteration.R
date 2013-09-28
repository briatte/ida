

# Set the counter.
n = 3
# Loop n times.
for(i in 1:n) {
  cat("Sheep #", i, "\n")
}



# Vectorized approach.
paste("Sheep #", 1:3)



# Set the counter.
i <- 5
# Decrease i by an increment of 1 until it reaches 0.
while(i > 0) {
  print(i <- i - 1)
}



# The iterative way: square i, square i + 1, square i + 2, square i + 3.
for(i in 1:3) print(i^2)
# The vectorized way: define i = { 1, 2, 3 } and square each i element.
(1:3)^2



# Number of possible conflicts in a pool of two roommates (single combination).
prod(1:2) / prod(1:2)
# With three roommates, there are three potential combinations (AB, BC and AC).
prod(1:3) / (prod(1:2) * prod(1:1))
# With three roommates, there are six potential combinations (AB, BC, CD, ...).
prod(1:4) / (prod(1:2) * prod(1:2))



# Explosive roommates function.
explosive_roommates = function(n) prod(1:n) / (prod(1:2) * prod(1:max(n - 2, 1)))
# Vector of x values.
x = 2:20
# Vector of y values.
y = sapply(x, explosive_roommates)
# Plot y against x.
qplot(x, y, geom = c("line", "point")) +
  labs(y = "Number of potential conflicts", x = "Number of roommates")


