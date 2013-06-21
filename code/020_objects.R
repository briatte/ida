

# Addition.
1 + 2
# Brackets.
(1 + 2) / 3
# Powers.
7^2
# Infinity.
1 - Inf
# And so on. These objects are...
class(7^2)



# A simple logical test with the natural logarithm.
log(1) > 0
# Guess why this result differs from the one above.
log(1) >= 0
# Equality requires TWO equal signs.
log(1) == 0
# Negation requires the "!" symbol.
log(1) != 1
# A more complex example using scientific notation.
1 + log10(1e7) == 8 * exp(1)^0
# And so on. These objects are...
class(1 > 1)



# The typical "hello world" text.
"Hello R World!"
# Now "pasted" from its elements.
paste("Hello", "R", "World", "!")
# Now through raw concatenation.
cat("Hello", "R", "World", "!\n")
# And so on. These objects are...
class("some text")



# Create a sequence of integers.
1:3
# Compute the sum of the sequence.
sum(1:3)
# Compute the product of the sequence.
prod(1:3)
# Compare the sum and product.
sum(1:3) == prod(1:3)



# This will break. Try it.
print(Hello World!)
# Press UpArrow, select text, add double quotes.
# This will now run fine.
print("Hello World")



# This needs quotes.
install.packages("ggplot2")
# This does not.
library(ggplot2)
# But it can.
library("ggplot2")
# Here's a less noisy way to load packages.
require(ggplot2)
# Thankfully, it also accepts quotes.
require("ggplot2")
# Oh, and single quotes will work too.
require('ggplot2')



# Print some text, the full date and some text again, with no separators.
paste0("Hello World! Today is ", date(), ".")


