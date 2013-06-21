

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



# Solver for the birthday problem between two random dates.
birthday <- function(n) { 
  1 - exp( - n^2 / (2 * 365) )
}
# Solver for the birthday problem applied to a single date.
myBirthday <- function(n) {
	1 - ( (365 - 1) / 365 ) ^ n
}



# Similar birthdays likelihood function for x = 1 2 3 4.
birthday(1:4)
# Single birthday likelihood function for x = 1 2 3 4.
myBirthday(1:4)



require(reshape)
# Set x values.
n = 200
# Create values data frame.
df = data.frame(n = 1:n, AnyTwoSame = birthday(1:n), SameAsMine = myBirthday(1:n))
# Collapse the data on x values.
df = melt(df, id = "n")
# Plot both functions.
qplot(data = df, x = n, y = value, colour = variable, geom = "line") + 
  scale_colour_brewer("", palette = "Set1") +
  labs(x = "Number of people in group", y = "Probability of each function")


