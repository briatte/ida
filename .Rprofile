##
## IDA STARTUP FILE 0.5 (2013-05-28)
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
    axis.title.x = element_text(vjust = -1),
    legend.key = element_rect(colour = "white")
  )
}

##
## ida.pages(): list all or selected course page filenames
##

ida.pages <- function(x = NULL) {
  # numbered files
  d = dir(pattern = "[index|0-9]+(.*).Rmd")
  # session number
  names(d) = suppressWarnings(as.numeric(substr(d, 1, 2)))
  # fix index to 0
  names(d)[which(is.na(names(d)))] = 0
  # ordered vector
  d = d[order(as.numeric(names(d)))]
  # selected pages
  if(is.null(x)) d else d[names(d) %in% x]
}

##
## ida.build(): knit the course from R Markdown to HTML
##

ida.build <- function(
  pages  = 0:12,
  repo   = "/Users/fr/Documents/Teaching/IDA",
  path   = "/Users/fr/Documents/Code/Websites/briatte.github.com/teaching/ida",
  backup = "admin/backup/ida", 
  html = TRUE) {
  require(knitr)
  
  # knitr setup
  opts_chunk$set(fig.path = "plots/", 
                 comment = NA, 
                 dpi = 100, 
                 fig.width = 7, 
                 fig.height = 5.3)
  
  # set course directory
  stopifnot(file.exists(path))
  stopifnot(file.exists(repo))
  setwd(repo)
  
  # backup code
  if(length(backup) > 1) {
    backup = paste(backup, Sys.Date(), "zip", sep = ".")
    zip(backup, dir(pattern = ".Rmd"))
  }

  # clean up
  file.remove(dir(pattern="[0-9]{3,}_\\w{1,}\\.html$"))
  file.remove(dir(pattern="[0-9]{3,}_\\w{1,}\\.md$"))
  
  all = ida.pages(pages)
  
  # run course
  lapply(all, FUN = function(x) {
    # do not script the first pages or the index
    if(!substr(x, 1, 2) %in% c("00", "12", "in"))
      purl(x, documentation = 0, output = paste0("code/", gsub("Rmd", "R", x)))
    # htmlify
    knit2html(x)
  })

  if(html) {
    # collect HTML
    html <- dir(pattern = "(index|[0-9]{3,}_\\w{1,}).html|style.css")
    # collect code
    code <- dir("code", pattern = "([0-9]{1,2}_\\w+).R$")
    # copy to website
    file.copy(html, path, overwrite = TRUE)
    if(length(code)) {
      code = paste0("code/", code)
      # drop empty files
      zero = which(file.info(code)$size == 1)
      message("These empty scripts are not uploaded:", paste0("\n", code[zero]))
      code = code[-zero]
      # copy other scripts
      file.copy(code, path, overwrite = TRUE)
    }
    
    # clean up
    file.remove(gsub("Rmd", "md", all))
    file.remove(gsub("Rmd", "html", all))
  }
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
## ida.load(): load a package, installing it if needed (for R 3.0.0)
##

ida.load <- function(x, load = TRUE, silent = FALSE) {
  # install
  if(!suppressMessages(suppressWarnings(require(x, character.only = TRUE)))) {
    dl <- try(install.packages(x, quiet = TRUE))
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
