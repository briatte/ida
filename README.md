# README

[Ivaylo Petev](http://ipetev.org/) and [myself](http://f.briatte.org/) use this repository to teach an undergraduate introduction to data analysis. [The course is here](http://f.briatte.org/teaching/ida/). [The syllabus is here](ida/raw/master/syllabus.pdf).

## HOWTO

The course is built from a set of 46 files formatted in R Markdown syntax. A few files are called from the `code/` and `data/` folders, but most datasets are downloaded on the fly.

* `knitr` geeks: the course is meant to fly as HTML: compile the whole thing by running `index.Rmd`. This is how the routine goes on my end:
    * knitting `syllabus.Rmd` will first clean up the workspace and all files but `.Rmd` files
    * it will then run all `.Rmd` scripts, producing `.R` and `.html` files
    * these files are finally copied to my GitHub Pages folder, which I then commit and sync
* `.Rprofile` nerds: [check the code](https://github.com/briatte/ida/blob/master/.Rprofile). I have coded a few things to help students with packages and data exploration.
    * `ida.load()` is a function to load a set of packages after installing them if needed
    * `ida.scan()` is a function to find which packages are used in a set of scripts
    * `ida.prep()` is a function to download course scripts and run the functions above.
* Typography lovers: the course pages use [Open Sans](https://www.google.com/webfonts#UsePlace:use/Collection:Open+Sans) and [Signika Negative](https://www.google.com/webfonts#UsePlace:use/Collection:Signika+Negative) from Google Web Fonts, where you can also download them.

Everything above got done on a MacBook Air running OS X 10.8, using Chrome, GitHub and Gist, R and RStudio, with some help from Terminal and TextMate. All scripts have been tested on Windows.

## HISTORY

`[Feb-2013]` The `.Rprofile` functions are now much more efficient, and the `knitr` routine has been slightly improved. The code is getting tidier in the early sessions.

`[Jan-2013]` All files are now chained to each other via navigational links. The `.Rprofile` starter file contains a utility to install and load packages. First code release.

## TODO

* Code:
    * take advantage of `source_gist` to call a few functions
    * acknowledge authors in `code/README` for all additional functions
    * unify `GET` method used to get data via HTTPS.
* Course:
    * tidy up code for all sessions
    * add setup instructions and homework (exercises, assignments, grading scheme)

> First release: January 2013.  
> Last revised: February 2013.
