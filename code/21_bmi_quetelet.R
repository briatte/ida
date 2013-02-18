# Quételet's original Body Mass Index function.
# Requires weight in kilograms and height in meters.
bmi.quetelet <- function(weight, height, digits = 2) {
  round(weight / (height^2), digits)
}

# Check if it works.
bmi.quetelet(65, 1.8)
bmi.quetelet(35, 1.8)
bmi.quetelet(95, 1.8)

# Let's assume my height is fixed at 1.80 m and my weight varies.
# BMI = weight / 1.8^2 = x / 3.24

# That's a simple linear function.
bmi.fixed.height <- function(x) {
  x / 3.24
}

# Let's plot it.
require(ggplot2)

# Plotting over a weight range of 35 to 155.
qplot(c(35, 155), stat = "function", fun = bmi.fixed.height, geom = "line")

# Let's save this for later use.
g <- qplot(c(35, 155), stat = "function", fun = bmi.fixed.height, geom = "line")

# Now add some axis titles.
g <- g + labs(x = "Weight (fixed height = 1.8)", y = "BMI")

# Now add a line to show when I become obese.
g <- g + geom_hline(yintercept = 30, linetype = "dashed")

# Now add a rectangle to fill the surface where I am obese.
g <- g + geom_rect(ymin = 30, ymax = Inf, xmin = -Inf, xmax = Inf, fill = "red", alpha = .2)

# Plot.
g

# Now the opposite: fixed weight at 65 kg, height varies.
bmi.fixed.weight <- function(x) {
  65 / x^2
}

# Plotting over a range of 1.40 to 2.40.
h <- qplot(c(1.4, 2.4), stat = "function", fun = bmi.fixed.weight, geom = "line")

# All options in one command.
h + labs(x = "Height (fixed weight = 65)", y = "BMI") + 
  geom_hline(yintercept = 30, linetype = "dashed", colour = "red") +
  geom_rect(ymin = 30, ymax = Inf, xmin = -Inf, xmax = Inf, fill = "red", alpha = .2)
