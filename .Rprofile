##
## IDA STARTUP FILE
##

require(utils, quietly = TRUE)
require(grid, quietly = TRUE)

cat("\nWelcome to Introduction to Data Analysis!\n")
cat("http://f.briatte.org/teaching/ida/\n\n")

set.seed(654321)

cat("- Adding space to ggplot2 graphics\n")

if("ggplot2" %in% installed.packages()[,1]) {
  suppressPackageStartupMessages(require(ggplot2, quietly = TRUE))
  theme_set(theme_grey())
  theme_update(
    axis.title.y = element_text(angle = 90, vjust = -.25),
    axis.title.x = element_text(vjust = -1),
    plot.margin = unit(c(1,1,1,1), "cm")
  )
} else {
  message("  ggplot2 is not installed, skipping customizations")
}

#
# ... package loader/installer
#

cat("- Adding getPackage() function\n")

getPackage <- function(pkg) {
  if(!suppressWarnings(require(pkg, character.only = TRUE, quietly = TRUE))) {
    try(install.packages(pkg, repos = "http://cran.us.r-project.org"), silent = TRUE)
    suppressPackageStartupMessages(library(pkg, character.only = TRUE, quietly = TRUE))
  }
  message("Loaded ",pkg)
}

#
# ... course packages
#

cat("- Adding list of course packages\n")

ida.packages <- function() {
  x <- list()
  x[['essentials']] <- c("foreach", "knitr", "devtools", "ggplot2")
  
  # Listed by first session of use.
  
  x[['40']]  <- c("gdata","WDI", "countrycode")
  x[['41']]  <- c("RCurl", "xlsx")
  x[['42']]  <- c("foreign", "Hmisc", "plyr", "reshape", "reshape2")
  x[['43']]  <- c("XML")
  x[['52']]  <- c("FactoMineR", "quantmod", "class", "rpart", "MASS")
  # unavailable for now (licensing issue):
  # https://github.com/andrie/ggdendro
  # x[['53']]  <- c("ggdendro")
  x[['61']]  <- c("data.table", "memisc")
  x[['81']]  <- c("GGally", "scales")
  x[['82']]  <- c("arm", "car")
  x[['91']]  <- c("zoo")
  x[['100']] <- c("maps", "mapdata", "spdep", "rworldmap")
  x[['101']] <- c("maptools", "classInt", "ggmap")
  x[['102']] <- c("googleVis")
  x[['111']] <- c("network", "sna", "ergm", "igraph", "tm")
  x[['113']] <- c("twitteR")
  
  # Unassigned packages.
  
  x[['plots']] <- c("vcd", "lattice", "RColorBrewer")
  x[['misc']]  <- c("lubridate", "stringr", "Snowball", "forecast", "rgrs")
  
  x <- unlist(x, use.names = FALSE)
  return(x)
}

#
# ... initializer
#

cat("- Adding setup utility\n")

ida.setup <- function() {
  if(!exists("ida.packages", mode = "function"))
    stop("ida.packages() does not exist")
  x <- ida.packages()
  
  if(!exists("getPackage", mode = "function"))
    stop("getPackage() does not exist")
  x <- sapply(x, getPackage)
}

# tell user how to load all

message("\nYou can now load all course packages by typing ida.setup()")

if(length(ida.packages()[!ida.packages() %in% installed.packages()[,1]])) {
  message("Note: some packages will be downloaded first\n")
}

cat("Enjoy your day.\n\n")