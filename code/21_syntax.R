

## # This will break. Try it by uncommenting the line.
## # print(Hello World!)
## # Press UpArrow, select text, add double quotes.
## # This will now run fine.
## print("Hello World")



## # This needs quotes.
## install.packages("ggplot2")
## # This does not.
## library(ggplot2)
## # So for consistency, we'll use quotes on both.
## library("ggplot2")
## # There's also another (less noisy) way to load packages.
## require(RCurl)
## # Thankfully, it also accepts quotes. We might use it.
## require("RCurl")
## # Oh, and single quotes can work too...
## library('ggplot2')
## # That covers the whole spectrum of quotes strangeness.
## require('RCurl')



# Print some text, the full date and some text again, with no separators.
cat("Hello World! Today is ", date(), ".", sep = "")



# Compute my Body Mass Index.
bmi <- round(703*134/(70^2),1)
# Create a text object (called a string).
assessment <- "normal"
# Modify the assessment statement if BMI is below 18 or above 25.
if(bmi < 18) assessment <- "below normal"
if(bmi > 25) assessment <- "above normal"
cat("My BMI is approximately", bmi, ", which is", assessment)



# A simple Body Mass Index function.
bmi <- function(weight, height, digits = 2) {
  round(weight*703/(height^2), digits)
}
# Check result: an object called 'bmi' now appears in your Workspace.
bmi
# This object is a function.
mode(bmi)
# Example, with default argument of 2 digits.
bmi(weight = 134, height = 70)
# Another example, this time with digits.
bmi(weight = 134, height = 70, digits = 0)


