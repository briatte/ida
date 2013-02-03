

# A sequence.
1:4



# Store it.
x <- c(1:4)
# Is it a vector?
is.vector(x)



# A vector of numbers.
x <- c(4, 6, 8)
# A vector of strings, i.e. characters, i.e. text.
y <- c("alea", "jacta", "est")
# A 'mixed' vector will be automatically converted.
z <- c(4, "a")



# Also a vector.
y <- "This is a vector."
# Check.
is.vector(y)
# Also a vector.
z <- 1
# Check.
is.vector(z)
# What about...
m <- cbind(1:3,4:6)
# What type (or class) is that?
class(m)



# Create vector of random exam grades.
exam <- c(7, 13, 19, 8, 12)
# Check result.
exam
# Compute mean of exam vector.
mean(exam)
# Compute median of exam vector.
median(exam)
# Descriptive statistics for exam vector.
summary(exam)



# Recall the exam object.
exam
# It's a vector.
is.vector(exam)
# Not a very long one.
length(exam)



# Select its first element; in context: show grade of first student.
exam[1]
# Select more than one element by listing which values you want.
exam[1:3]
# Select a vector of values: show grades of students no. 1, 2, 3 and 5.
exam[c(1:3,5)]
# In context, it makes more sense to simply hide student no. 4's grade.
# Thanks to the student who brought up that point in class!
exam[-4]
# Vectors can be logical.
exam >= 10
# Select a logical vector of values.
exam[exam >= 10]



# The exam object is not a matrix.
is.matrix(exam)
# If you make it into a matrix, the vector becomes a column of values.
as.matrix(exam)



# Show length of grades vector.
length(exam)
# Create a random grades vector of same length.
essay <- as.integer(20 * runif(5))
# Check result.
essay
# Form a matrix.
grades <- cbind(exam, essay)
# Check result.
grades



# Compute student average.
final <- rowMeans(grades)
# Combine to grades matrix.
grades <- cbind(grades, final)
# Check result.
grades
# Compute mean exam and essay grades.
colMeans(grades)



# How many rows?
nrow(grades)
# How many columns?
ncol(grades)
# Do they have names?
dimnames(grades)
# Create a student id sequence 1, 2, 3, ...
id <- c(1:nrow(grades))
# Check result.
id
# Assign it to row names.
rownames(grades) <- id
# Check result.
grades



# First row, second cell.
grades[1,2]
# First row.
grades[1, ]
# First two rows.
grades[1:2, ]
# Third column.
grades[, 3]
# Descriptive statistics for final grades.
summary(grades[, 3])
# Descriptive statistics for all matrix columns.
summary(grades)



# Create a text object based on a logical condition.
pass <- ifelse(grades[, 3] >= 10, "Pass", "Fail")
# Check result.
pass



## cbind(grades, pass)



# Understand what happens when you factor a string (text) variable.
factor(pass)
# The numeric matrix is preserved if 'pass' is added as a factor.
cbind(grades, factor(pass))
# Final operation. The '=' assignment gives a name to the column.
grades <- cbind(grades, pass = factor(pass))
# Marvel at your work.
grades


