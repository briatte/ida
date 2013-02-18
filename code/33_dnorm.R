library(ggplot2)
library(reshape)

qplot(c(-5, 5), geom = "blank") +
  stat_function(fun = dnorm, color = "red") +
	theme_bw()

qplot(c(-5, 15), geom = "blank") +
  stat_function(fun = dnorm, args = list(mean = 1, sd = 1), color = "red") + 
  stat_function(fun = dnorm, args = list(mean = 2, sd = 2), color = "green") + 
  stat_function(fun = dnorm, args = list(mean = 4, sd = 3), color = "blue") +
  theme_bw()

run.sims <- function(n.sims)
{
	x <- rnorm(n.sims, 0, 1)
	y <- rnorm(n.sims, 2, 2)
	z <- rnorm(n.sims, 4, 3)
	results <- data.frame(x, y, z)
 
	return(results)
}
 
r <- run.sims(150)

names(r) <- c("N(0,1)", "N(2,1)", "N(4, 1)")

r <- melt(r, variable = "X")
head(r)

qplot(data = r, x = value, fill = X, alpha = I(.2), geom="density") +
  theme_bw()
  
qplot(data = r, x = value, fill = X, alpha = I(.2), geom="density") +
  theme_bw() + facet_grid(X ~ .)

qplot(data = r, x = value, fill = X, alpha = I(.2), geom="density") +
  stat_function(fun = dnorm, color = "red") + 
  stat_function(fun = dnorm, args = list(mean = 2, sd = 2), color = "green") + 
  stat_function(fun = dnorm, args = list(mean = 4, sd = 3), color = "blue") + 
  theme_bw() + facet_grid(X ~ .)
