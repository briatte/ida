

# Continuing with QOG data. 
require(arm)
require(car)
require(ggplot2)
require(GGally)

# Extract UNDP data.
qog.x <- qog.d[, grepl("undp_", names(qog.d))]

# Subset to full data.
qog.x <- na.omit(qog.x)

# Correlation matrix.
cor(qog.x)

# Correlation plot (arm).
corrplot(qog.x, color = TRUE)

# Scatterplot matrix (car).
scatterplotMatrix(qog.x, spread=FALSE, lty.smooth=2)

# Scatterplot matrix (GGally).
ggpairs(qog.x)


