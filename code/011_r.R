

# A string of characters.
"Hello R World!"
# A function that returns a string.
date()
# A numeric result.
1 + 2
# A logical statement.
1 / (2 + 3) == .2
# A vector of integers.
1:3
# A function that returns a matrix.
as.matrix(1:3)



# A vector of lowercase letters.
letters[1:5]
# A vector of UPPERCASE letters.
LETTERS[1:5]



# A sequence of integers.
1:3
# The same result.
seq(1, 3)
# A sequence of floating point numbers.
seq(from = 1, to = 3, by = .5)
# A function with an optional logical argument.
order(1:3, decreasing = TRUE)
# The same result.
rev(1:3)
# The order function in its default behaviour.
i <- sample(5)
j <- order(i)
list(i, j)
# Using hard brackets for vector notation.
i[order(i)]
# The sort function for character strings.
p <- "we come in peace"
p <- strsplit(p, " ")
p <- unlist(p)
sort(p)



# Create an object called x.
x <- "Hello"
# Create an object called y.
y <- "World"



# Combine x and y into a vector called z.
z <- c(x, y)



# Print the object z on screen.
print(z)
# Just type its name do do the same.
z


