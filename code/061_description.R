

# Load the data from file (created in Session 4.1).
dk_data <- read.csv("data/dailykos.csv")
# Review columns 1-5.
head(dk_data)[1:5]



# Create a variable holding states.
dk_data$state <- substr(dk_data$CD,1,2)
# Check result: the new variable is at the end.
str(dk_data)



# Load data.table package.
library(data.table)
# Convert nonmissing data to a data.table object.
dk_table <- data.table(na.omit(dk_data))
# Check result.
head(dk_table)
# Compute mean Obama score by state.
dk_state <- dk_table[, mean(Obama.2012), by=state]
# Check result.
head(dk_state)



# Sort the data.
dk_state$state <- reorder(dk_state$state, dk_state$V1)
# Plot by decreasing electoral support.
p <- ggplot(dk_state, aes(V1, state)) + geom_point() + 
  geom_vline(xintercept = 50, colour="darkgray", linetype = "longdash") +
  labs(x = "% of popular vote for Obama in 2012", y = "State"); p



# Create a red/blue variable.
dk_state$color <- ifelse(dk_state$V1 > 50, "blue", "red")
# Add a new layer of colored dots.
p + geom_point(colour=dk_state$color)


