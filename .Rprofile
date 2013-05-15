##
## IDA STARTUP FILE 0.3 (2013-02-26)
##

require(utils, quietly = TRUE)
require(grid, quietly = TRUE)

##
## setup course
##

cat("\nWelcome to Introduction to Data Analysis!\n")
cat(ida.site <- "http://f.briatte.org/teaching/ida/", "\n\n")

if(!file.exists("code")) dir.create("code")
if(!file.exists("data")) dir.create("data")

set.seed(654321)

##
## ggplot2 tweaks
##

if("ggplot2" %in% installed.packages()[,1]) {
  suppressPackageStartupMessages(require(ggplot2, quietly = TRUE))
  # black and white theme, large text
  theme_set(theme_bw(18))
  theme_update(
    panel.border = element_rect(fill = NA, color = "white"), 
    panel.grid.major.x = element_line(color = "white"),
    panel.grid.minor.x = element_line(color = "white"),
    plot.margin = unit(c(1, 1, 1, 1), "cm"),
    plot.title = element_text(face = "bold", vjust = 1),
    axis.title.y = element_text(angle = 90, vjust = -.25),
    axis.title.x = element_text(vjust = -1)
  )
}

##
## ida.links(): list all Markdown links in a list of pages
##

ida.links <- function(x = NULL, detail = FALSE) {
  if(is.null(x)) x = dir(pattern = "*.Rmd")
  # parse
  links <- sapply(x, FUN = function(x) {
    conn <- file(x)
    text <- readLines(conn, warn = FALSE)
    text <- text[grepl("(\\[[a-z-]+\\]): http(.*)", text)]
    close(conn)
    text
  })
  # format
  if(!detail)
    links <- unique(unlist(links))
  return(links)
}

##
## ida.scan(): find all packages called in a list of scripts
##

ida.scan <- function(x = NULL, detail = FALSE) {
  # paths
  if(!is.character(x))
    x <- paste("code", dir(path = "code", pattern="[0-9]+(.*)\\.R"), sep = "/")
  # parse
  libs <- sapply(x, FUN = function(x) {
    conn <- file(x)
    text <- readLines(conn, warn = FALSE)
    text <- text[grepl("(library|require)\\(([a-zA-Z0-9]*)\\)", text)]
    pkgs <- gsub(".*(library|require)\\(([a-zA-Z0-9]*)\\).*", "\\2", text)
    close(conn)
    unique(pkgs)
  })
  # format
  if(!detail)
    libs <- unique(unlist(libs))
  return(libs)
}

##
## ida.load(): load a package, installing it if needed
##

ida.load <- function(x, load = TRUE, silent = FALSE) {
  # install
  if(!suppressMessages(suppressWarnings(require(x, character.only = TRUE)))) {
    dl <- try(install.packages(x), silent = TRUE)
    if(class(dl) == "try-error")
      stop("The package ", x, "could not be downloaded.")
  }
  # load
  if(load) {
    suppressPackageStartupMessages(library(x, character.only = TRUE))
    if(!silent) message("Loaded package: ", x)
  }
}

##
## ida.prep(): prepare for a course session by getting and scanning the scripts
##

ida.prep <- function(x, index = ida.site, replace = TRUE, scan = TRUE) {
  if(!x %in% 0:12) stop("Please type a session number between 0 and 12.")
  message("Downloading course files for session ", x, "...")
  conn <- url(index)
  text <- readLines(conn, warn = FALSE)
  close(conn)
  text <- text[grepl("[0-9]+_(.*).html", text)]
  prep <- gsub("(.*)\\\"([0-9]+)(_.*).html(.*)", "\\2\\3", text)
  prep <- prep[grepl(paste0("^(", paste0(x, 0:3, collapse = "|"), ")_"), prep)]
  # download
  for(i in 1:length(prep)) {
    file <- paste0(prep[i], ".R")
    path <- paste("code", file, sep = "/")
    if(!file.exists(path) | replace) {
      dl <- try(suppressWarnings(download.file(paste0(index, file), 
                                               destfile = path, quiet = TRUE)), 
                silent = TRUE)
      if(class(dl) == "try-error") {
        message("Failed to download file: ", file)
        prep[i] <- NA
      }
      else {
        message("Successfully downloaded: ", file)
        prep[i] <- path
      }
    }
    else {
        message("Skipped existing file: ", file)
      prep[i] <- path
    }
  }
  message("\nThe files are in your code folder.")
  # scan
  libs <- ida.scan(na.omit(prep))
  if(length(libs) & scan) {
    message("\nSome packages are required to run them:\n", paste(libs, collapse = ", "), "\n")
    x <- lapply(libs, ida.load)
  }
  # bye
  message("\nHappy coding!\n")
}

cat("Course functions ready.\nEnjoy your day.\n\n")

## kthxbye
