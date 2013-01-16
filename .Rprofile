testing <- function() {
  library(utils)
  try(remove.packages("Snowball"))  
}

testing()

#
# ... startup: establish package list
#

course.packages <- function() {
  x <- list(c("foreach", "knitr"))
  
  # Listed by first session of use.
  x[[11]]  <- c("ggplot2", "grid")
  x[[41]]  <- c("RCurl", "xlsx")
  x[[42]]  <- c("foreign", "Hmisc", "plyr", "reshape")
  x[[61]]  <- c("data.table")
  x[[91]]  <- c("GGally")
  x[[111]] <- c("network", "sna", "ergm", "igraph", "tm")
  x[[113]] <- c("twitteR")

  # Unassigned packages.
  x[[999]] <- c("zoo", "Snowball","GGally","googleVis")
  
  return(x)
}

course.setup <- function() {
  l <- course.startup()
  l <- unlist(l)
  
  # (1) detect not installed
  toinstall <- l[!l %in% installed.packages()[,1]]
  
  # (2) install
  x <- lapply(toinstall, install.packages, repos = "http://cran.us.r-project.org")
  
  # (3) everything should be fine now
  installed <- l[l %in% installed.packages()[,1]]
  
  # (4) load all
  x <- lapply(installed, library, character.only = TRUE)
}

# Run without messages.
# suppressPackageStartupMessages(course.startup())

#
# ... ggplot2 tweaks
#

course.prefs <- function() {
  # Add space to ggplot2 axis titles in default theme.
  library(ggplot2)
  library(grid)
  
  default.ggplot <- theme_set(theme_grey())
  default.ggplot <- theme_update(
    # text = element_text(family = "Avenir", face = "plain"),
    axis.title.y = element_text(angle = 90, vjust = -.25),
    axis.title.x = element_text(vjust = -1),
    plot.margin = unit(c(1,1,1,1), "cm")
  )  
}

set.seed(654321)
cat("Welcome!", date(), "\n") 
