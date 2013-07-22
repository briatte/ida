##
## IDA STARTUP FILE 0.7 (2013-07-22)
##

require(utils, quietly = TRUE)
require(grid, quietly = TRUE)

##
## setup course
##

cat("\nWelcome to Introduction to Data Analysis!\n")
cat(ida.site <- "http://f.briatte.org/teaching/ida/", "\n\n")

if(!file.exists("backup")) dir.create("backup")
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
## ida.files(): list all or selected course page filenames
##

ida.files <- function(x = 0:12) {
  # numbered files
  d = dir(pattern = "[index|ex|0-9]+(.*).Rmd")
  # session number
  names(d) = suppressWarnings(as.numeric(substr(gsub("^ex", "0", d), 1, 2)))
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
  x      = 0:12,
  repo   = getwd(),
  path   = "html",
  backup = "backup") {
  require(knitr)
  
  # knitr setup
  opts_chunk$set(comment = NA, 
                 dpi = 100, 
                 fig.width = 7, 
                 fig.height = 5.3)
  
  # set course directory
  stopifnot(file.exists(repo))
  setwd(repo)
  
  if(repo == "/Users/fr/Documents/Teaching/IDA")
    path = "/Users/fr/Documents/Code/Websites/briatte.github.com/teaching/ida"

  # backup code
  if(length(backup) > 1) {
    stopifnot(file.exists(backup))
    backup = paste(paste0(backup, "/ida"), Sys.Date(), "zip", sep = ".")
    zip(backup, dir(pattern = ".Rmd"))
  }

  # clean up
  file.remove(dir(pattern="[0-9]{3,}_\\w{1,}\\.html$"))
  file.remove(dir(pattern="[0-9]{3,}_\\w{1,}\\.md$"))
  
  # get pages
  all = ida.files(x)
  
  # run course
  lapply(all, FUN = function(x) {
    # do not script the first pages or the index
    if(!substr(x, 1, 2) %in% c("00", "12", "in"))
      purl(x, documentation = 0, output = paste0("code/", gsub("Rmd", "R", x)))
    # htmlify
    knit2html(x)
  })

  if(is.character(path)) {
    # check folder
    stopifnot(file.exists(path))
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
      file.remove(code[zero])
      code = code[-zero]
      # copy other scripts
      file.copy(code, path, overwrite = TRUE)
    }
    
    # clean up
    clean = file.remove(gsub("Rmd", "html", all))
    clean = file.remove(gsub("Rmd", "md", all))
  }
}

cat("Course functions ready.\nEnjoy your day.\n\n")

## kthxbye
