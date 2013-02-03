##
## IDA STARTUP FILE 0.1 (2013-02-03)
##

require(utils, quietly = TRUE)
require(grid, quietly = TRUE)

cat("\nWelcome to Introduction to Data Analysis!\n")
cat("http://f.briatte.org/teaching/ida/\n")

set.seed(654321)

##
## ggplot2 tweaks
##
## - set black and white theme as default
## - set font size to something visible
## - add space around axis titles
##

if("ggplot2" %in% installed.packages()[,1]) {
  suppressPackageStartupMessages(require(ggplot2, quietly = TRUE))
  theme_set(theme_bw(18))
  theme_update(
    axis.title.y = element_text(angle = 90, vjust = -.25),
    axis.title.x = element_text(vjust = -1),
    plot.margin = unit(c(1,1,1,1), "cm")
  )
}

##
## lookfor() function
##
## - works like the Stata command
## - accepts multiple search keywords
## - supports memisc data objects
##

lookfor <- function(data, keywords = c("weight", "sample"), labels = TRUE, ignore.case = TRUE) {
  n <- names(data)
  if(!length(n) > 0) stop("there are no names to search in that object")
  # search function
  q <- paste(keywords, collapse="|")
  look <- function(x, y) { grep(x, y, ignore.case = ignore.case) }
  # standard search
  x <- look(q, n)
  variable <- n[x]
  # memisc search
  lib <- suppressPackageStartupMessages(suppressWarnings(require(memisc)))
  obj <- grepl("data.set|importer", class(data))
  if(lib & obj) {
    # search labels
    l <- as.vector(description(data))
    if(labels) {
      # search labels
      y <- look(q, l)
      # remove duplicates, reorder
      x <- sort(c(x, y[!(y %in% x)]))
    }
    # add variable labels
    variable <- n[x]
    label <- l[x]
    variable <- cbind(variable, label)
  }
  # output
  if(length(x) > 0) return(as.data.frame(variable, x))
  else message("Nothing found. Sorry.")
}

##
## getPackage(): package loader/installer
##

getPackage <- function(pkg, silent = FALSE) {
  if(!suppressMessages(suppressWarnings(require(pkg, character.only = TRUE, quietly = TRUE)))) {
    try(install.packages(pkg, repos = "http://cran.us.r-project.org", type = "source"), silent = TRUE)
    suppressPackageStartupMessages(library(pkg, character.only = TRUE, quietly = TRUE))
  }
  if(!silent) message("Loaded ", pkg)
}

##
## ida.packages(): package listing
##

ida.packages <- function(mode = "install") {
  x <- list()
  
  # Listed by first session of use. Grossly inefficient but human-readable.
  
  x[['11']] <- c("foreach", "knitr", "devtools", "ggplot2", "RCurl")
  x[['22']]  <- c("randomNames", "reshape")
  x[['40']]  <- c("gdata", "WDI", "countrycode")
  x[['41']]  <- c("xlsx", "httr")
  x[['42']]  <- c("foreign", "Hmisc", "plyr", "reshape2")
  x[['43']]  <- c("XML")
  x[['52']]  <- c("FactoMineR", "quantmod", "class", "rpart", "MASS")
  x[['53']]  <- c("ggdendro")
  x[['61']]  <- c("data.table", "memisc", "survey")
  x[['81']]  <- c("GGally", "scales")
  x[['82']]  <- c("arm", "car")
  x[['91']]  <- c("zoo")
  x[['92']]  <- c("astsa", "mgcv", "splines")
  x[['100']] <- c("maps", "mapdata", "spdep", "rworldmap")
  x[['101']] <- c("maptools", "classInt", "ggmap")
  x[['102']] <- c("googleVis")
  x[['111']] <- c("network", "sna", "ergm", "igraph")
  x[['113']] <- c("twitteR", "wordcloud")
  
  # Unassigned packages.
  
  x[['plots']]   <- c("vcd", "lattice", "RColorBrewer")
  x[['data']]    <- c("lubridate", "stringr", "RSQLite", "sqldf", "SAScii")
  x[['models']]  <- c("lme4", "forecast", "sem", "lavaan", "mosaic")
  x[['text']]    <- c("tm", "Snowball")
  x[['misc']]    <- c("ProjectTemplate", "descr", "rgrs", "psych")
  
  x <- unlist(x, use.names = FALSE)
  
  if(mode == "all") {
    # list all
    return(x)
  }
  else if(mode == "missing") {
    # list missing
    x[!x %in% installed.packages()[,1]]
  } else {
    # install missing, load all
    stopifnot(exists("getPackage", mode = "function")) 
    ida <- lapply(x, getPackage)
  }
}

message("\nYou can now load all course packages by typing ida.packages()")

if(length(ida.packages("missing")) > 0) {
  message("Some packages will be downloaded first\n")
}

cat("Enjoy your day.\n\n")

## kthxbye
