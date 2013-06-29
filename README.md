# README

[Ivaylo Petev][ivo] and [myself][fr] use this repository to teach an undergraduate introduction to data analysis. The course is [online][ida].

[ivo]: http://ipetev.org/
[fr]: http://f.briatte.org/
[ida]: http://f.briatte.org/teaching/ida/

If you are reading the course on its [online pages][ida], just replace the `.html` extension of a page by `.R` to download the underlying code. 

## HOWTO

The course pages are formatted in R Markdown syntax and were converted to HTML with [knitr](http://yihui.name/knitr/) 1.2:

	install.packages("knitr")
	citation("knitr")

The knitting routine is in the [`.Rprofile`](ida/blob/master/.Rprofile). To compile the whole course, set the `IDA` folder as your working directory and then type `ida.build()` (takes a bit more than five minutes on optic fiber).

Other files are called from the `code/` and `data/` folders. Most datasets are downloaded on the fly, so you will need to be online to run the code properly.

## DOCS

* Check the [syllabus][syll] for a quick overview.
* Check the [wiki][wiki] for additional content.

[syll]: ida/raw/master/syllabus.pdf
[wiki]: https://github.com/briatte/ida/wiki/

The whole course was coded and taught with [RStudio][rs]. The code was ran on R 2.15.2, 2.15.3 and 3.0.0, on a MacBook Air running OS X 10.8. Most plots use [ggplot2][gg] version 0.9.3.1 (just in case compatibility breaks at some point).

[rs]: http://www.rstudio.com/
[gg]: http://docs.ggplot2.org/current/

Bits and pieces of the code were posted to [Gist][gist], [RPubs][rpubs] and [Stack Overflow][so] during development. Thanks to the great R developer and user communities that live online, and which we are now proud to count ourselves in.

[gist]: https://gist.github.com/briatte
[rpubs]: http://rpubs.com/briatte
[so]: http://stackoverflow.com/

If you share the spirit of all this, you should consider joining the [Foundation for Open Access Statistics][foas] and check out places like [OpenCPU][ocpu], the [Open Knowledge Foundation][okfn] and other initiatives in open access, open data, open source and open science.

[foas]: http://www.foastat.org/
[ocpu]: https://public.opencpu.org/
[okfn]: http://okfn.org/

## HISTORY

__Jun-2013__: first draft. Everythingn kind of works, Sessions 5--7 are unlisted, the `code` folder contains a few more exercises. That's it for now!

__May-2013__: added more course content and better resolution (100dpi) for all plots.

__Apr-2013:__ added a lot of course content and cleaner plots. Also adding the [R-2013-Lyon](R-2013-Lyon) folder for a conference presentation on the course.

__Mar-2013:__ reviewed course structure: less files, more code, tons of new examples and exercises.

__Feb-2013:__ more efficient `.Rprofile` functions and improved `knitr` routine, tidier code on the early sessions.

__Jan-2013:__ first release.

> First release: January 2013.  
> Last revised: June 2013.
