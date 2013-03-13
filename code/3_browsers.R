
## IDA Exercise 3
## --------------


# Welcome again.
# Let's write up a function and then learn about functional programming.


# Herfindhal-Hirschman Index (HHI)
# --------------------------------

# The HHI is a measure of market concentration based on firms and market shares.
# The example below uses Internet browsers and Wikimedia 2012 usage shares.

# Define firms.
browsers <- c("Chrome", "MSIE", "Firefox", "Safari", "Opera", "Others")

# Define usage shares.
usage <- c(37.2, 26.17, 23.18, 6.79, 3.72, 2.94)

# Make a data frame.
df <- data.frame(browsers, usage)

# Check.
df

# That deserves a plot, doesn't it?
require(ggplot2)

# Make sure the browsers will be ordered by usage share.
df$browsers <- reorder(browsers, usage)

# Quick horizontal bar plot.
g <- qplot(data = df, x = browsers, y = usage, geom = "bar") + coord_flip()

# Show with axis titles.
###g + labs(y = "Usage share on Wikimedia in 2012", x = "Internet browsers")

# The HHI function is f: \sum s^2 where s are the market shares.
hhi <- function(x) {
	# sum of squares
	hhi <- sum(x^2)
	# send back result
	return(cat("HHI =", hhi, "\n"))
}

# Example below. The usage shares need to be expressed as a fraction of 1.
hhi(usage / 100)


# Defensive programming
# ---------------------

# You have survived R so far. Now is time to teach R how to survive you.
# In other words: how can we learn R to tolerate our mistakes?

# Here's a simple way to break the Herfindhal index function shown above.
### hhi(browsers)

# It's a simple mistake: we have given the function the browser names.
# If you give text instead of numbers to the function, it chokes.

# What we would therefore like is to prevent that kind of mistake.
# Implementing consistency checks is part of defensive programming. 

# Here's a way to do it.
hhi <- function(x) {
	# check argument
	if(!is.numeric(x)) stop("Please provide a numeric vector of values")
	# sum of squares
	hhi <- sum(x^2)
	# send back result
	return(cat("HHI =", hhi, "\n"))
}

# The stop() function interrupts execution and sends a message.
###stop("Argh, that did not work.")

# Now see what happens.
###hhi(browsers)

# There's another issue: shares need to be expressed as a fraction of 1.
# If the user submits percentages (sum = 100%), the HHI goes up to 10,000.

# Here's a way to fix that.
hhi <- function(x) {
	# check argument
	if(!is.numeric(x)) stop("Please provide a numeric vector of values")
	# check percentages
	if(sum(x) == 100) {
		message("Percentages converted to fractions")
		x <- x / 100
	}
	# sum of squares
	hhi <- sum(x^2)
	# send back result
	return(cat("HHI =", hhi, "\n"))
}

# The message() function just returns a note to the user (in red ink, though).
message("Keep calm and carry on.")

# The function now deals with percentages itself and tells the user about it.
hhi(usage)

# Finally, the data can be flawed if the market shares do not add up to 1.
# We decide to be tolerant and simply warn the user if that is the case.

# Final function.
hhi <- function(x) {
	# check argument
	if(!is.numeric(x)) stop("Please provide a numeric vector of values")
	# check percentages
	if(sum(x) == 100) {
		message("Percentages converted to fractions")
		x <- x / 100
	}
	# check sum
	if(sum(x) != 1) warning("Shares do not sum up to 1")
	# sum of squares
	hhi <- sum(x^2)
	# send back result
	return(cat("HHI =", hhi, "\n"))
}

# The warning() function prints a special kind of red-ink message.
warning("Something is rotten in the State of Denmark.")

# Final example, excluding Google Chrome's share to illustrate the warning.
hhi(usage[-1])


# Conditions
# ----------

# The flow control examples above use if() conditions, which are often useful.
# You might know these statements from other programs like *cough* "Excel".

# Here's an example with voting age.
age <- 19

# A simple if() statement.
if(age >= 18) message("You can vote anywhere in the European Union.")
	
# Now if you want to deal with both situations, you need more stuff.
# Just like every other structure with curly brackets, select all lines to run.
if(age >= 18) {
	message("You can vote anywhere in the European Union.")
} else {
	message("Sorry, you are too young to vote in most of the European Union.")
}

# The ifelse() function is handy to deal with either/or situations.
message("You ", ifelse(age >= 18, "can", "cannot"), " vote anywhere in the EU.")

# The second argument of ifelse() is returned if the first one is TRUE.
# The third and last argument of ifelse() is returned if the first one is FALSE.


# Normalized HHI
# --------------

# The HHI varies from 1/N to 1, where N is the number of firms. There is a
# normalized version of it that varies from 0 to 1. Check the formula online.

# We improve our function by offering a choice to the user.
hhi <- function(x, normalized = FALSE) {
	# check argument
	if(!is.numeric(x)) stop("Please provide a numeric vector of values")
	# check percentages
	if(sum(x) == 100) {
		message("Percentages converted to fractions")
		x <- x / 100
	}
	# check sum
	if(sum(x) != 1) warning("Shares do not sum up to 1")
	# sum of squares
	hhi <- sum(x^2)
	# normalize if asked
	if(normalized) {
		message("HHI normalized to [0, 1]")
		hhi <- (hhi - 1 / length(x)) / (1 - 1 / length(x))
	}
	# send back result
	return(cat("HHI =", hhi, "\n"))
}

# Example, not normalized (the default choice, as option normalized is FALSE).
hhi(usage)

# Example, normalized.
hhi(usage, normalized = TRUE)

# Theoretical case of perfectly split market shares over two firms.
eq <- c(.5, .5)
# HHI, equal to 1/N where N = 2 firms.
hhi(eq)
# Normalized HHI.
hhi(eq, normalized = TRUE)

# Theoretical case of perfectly uniform market shares over 8 firms.
eq <- rep(1/8, times = 8)
# Check.
eq
# HHI, equal to 1/N where N = 8 firms.
hhi(eq)
# Normalized HHI.
hhi(eq, normalized = TRUE)


# Applied example
# ---------------

# It would be interesting to see how consumer preferences in Internet browsers
# have changed over the years. We will compute the HHI for a few recent years.
# Do not mind the #' + annotations, which have stuck from a previous draft.

#+ setup, message=FALSE
# Load packages.
require(ggplot2)
require(reshape)
require(XML)

#' # Browser usage and market concentration measured by the normalized Herfindhal-Hirschman Index

#' The data are from [StatCounter][1], cited at Wikipedia.
#' [1]: http://gs.statcounter.com/#browser-ww-monthly-200807-201301
#' Thanks to Juba for a [slight optimization][2] in the data cleaning.
#' [2]: http://stackoverflow.com/questions/14871249/can-i-use-gsub-on-each-element-of-a-data-frame

# Load the data.
if(!file.exists(file <- "data/browsers.csv")) {
  # Target a page with data.
  url <- "http://en.wikipedia.org/wiki/Usage_share_of_web_browsers"
  # Get the twelth table.
  tbl <- readHTMLTable(url, which = 12, as.data.frame = FALSE)
  # Extract the data.
  data <- data.frame(tbl[-7])
  # Clean numbers.
  data[-1] <- as.numeric(gsub("%", "", as.matrix(data[-1])))
  # Clean names.
  names(data) <- gsub("\\.", " ", names(data))
  # Normalize.
  data[-1] <- data[-1] / 100
  # Format dates.
  data$Date <- paste("01", data[, 1])
  # Check result.
  head(data)
  # Save.
  write.csv(data, file, row.names = FALSE)
} else {
  # Load from CSV.
  data <- read.csv(file)
}
# Convert dates.
data$Date <- strptime(data$Date, "%d %B %Y")

#' The normalized [Herfindhal-Hirschman Index][3] (HHI) is 
#' $HHI^* = {\left ( HHI - 1/N \right ) \over 1-1/N }$, 
#' with $HHI =\sum_{i=1}^N s_i^2$ 
#' where $s$ is the usage share of each of $N$ browsers.
#' [3]: https://en.wikipedia.org/wiki/Herfindahl_index

# Normalized Herfindhal-Hirschman Index.
HHI <- (rowSums(data[-1]^2) - 1 / ncol(data[-1])) / (1 - 1/ncol(data))
# Add dates.
HHI <- data.frame(HHI, Date = data$Date)

# Reshape.
melt <- melt(data[-7], id = "Date", variable = "Browser")

#' The plot uses LOESS smoothing. A better but longer job would use splines.
#+ plot, message=FALSE, tidy=FALSE, warning=FALSE, fig.width=9

# Time series.
ggplot(melt, aes(x = Date)) + labs(y = "", x = "") + theme_bw(16) +
  geom_smooth(aes(y = value, color = Browser, fill = Browser), alpha = .2) + 
  geom_smooth(aes(y = HHI, linetype = "HHI"), HHI, se = FALSE, color = "black") +
  scale_linetype_manual(name = "Market\nconcentration", values = c("HHI" = "dashed"))

# Enjoy your day.
# 2013-03-01
