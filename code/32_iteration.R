

# Set the counter.
n <- 3
# Loop n times.
for(i in 1:n) {
  cat("Hello!", i, "\n")
}



# Set the counter.
n <- 9
# Create an empty vector.
sequence <- NULL
# Loop over 9 values.
for(i in 1:n) {
  # Add i to the sequence.
  sequence <- c(sequence, i)
  # Mean of the sequence.
  print(mean(sequence))
}
# Show final result.
sequence



# Set the counter.
i <- 5
# Decrease i by an increment of 1 until it reaches 0.
while(i > 0) {
  print(i <- i - 1)
}


