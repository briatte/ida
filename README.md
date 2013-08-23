# README

[Ivaylo Petev][ivo] and [myself][fr] use this repository to teach an undergraduate introduction to data analysis. The course is [online][ida].

[ivo]: http://ipetev.org/
[fr]: http://f.briatte.org/
[ida]: http://f.briatte.org/teaching/ida/

If you are reading the course on its [online pages][ida], just replace the `.html` extension of a page by `.R` to download the underlying code. 

## HOWTO

The course pages are formatted in R Markdown syntax and were converted to HTML with [knitr][knitr] 1.4:

[knitr]: http://yihui.name/knitr/

	install.packages("knitr")
	citation("knitr")

The knitting routine is in the [`.Rprofile`](.Rprofile). To compile the whole course, set the `IDA` folder as your working directory and then type `ida.build()` (takes a bit more than five minutes on optic fiber).

Other files are called from the [`code/`](https://github.com/briatte/ida/blob/master/code/README.md) and [`data/`](https://github.com/briatte/ida/blob/master/data/README.md) folders. Most datasets are downloaded on the fly if they are missing from the `data/` folder, so make sure that you are online while running the scripts.

The whole course was coded and taught with [RStudio][rs]. The code was ran on R 2.15.2, 2.15.3, 3.0.0 and 3.0.1, on a MacBook Air running OS X 10.8 and Mac OS X 10.9. Most plots use [ggplot2][gg] version 0.9.3.1 (just in case compatibility breaks at some point).

[rs]: http://www.rstudio.com/
[gg]: http://docs.ggplot2.org/current/

## CREDITS

Thanks to the [Sciences Po Reims][spr] staff, who offered invaluable support, and to the small group of students who enrolled in (and survived to) the course. The [R-2013-Lyon](R-2013-Lyon) slides have a bit more detail on the practicals.

[spr]: http://college.sciences-po.fr/sitereims/

Bits and pieces of the code were posted to [Gist][gist], [RPubs][rpubs] and [Stack Overflow][so] during development. Thanks to the great R developer and user communities that live online, and which we are now proud to count ourselves in.

[gist]: https://gist.github.com/briatte
[rpubs]: http://rpubs.com/briatte
[so]: http://stackoverflow.com/

If you share the spirit of all this, you should consider joining the [Foundation for Open Access Statistics][foas] and check out places like [OpenCPU][ocpu], the [Open Knowledge Foundation][okfn] and other initiatives in open access, open data, open source and open science.

[foas]: http://www.foastat.org/
[ocpu]: https://public.opencpu.org/
[okfn]: http://okfn.org/

## HISTORY

__Aug 2013__: better data management, with large or multiple-file datasets read from ZIP archives. Switched datasets to `.csv` [thanks to GitHub](https://github.com/blog/1601-see-your-csvs).

__Jul 2013__: typos and broken links. Removed some functions in `.Rprofile` that are now [part of](https://github.com/juba/questionr/blob/master/R/utils.r) the `questionr` package.

__Jun-2013__: first draft. Everything kind of works, Sessions 5--7 are unlisted, the `code/` folder contains a few more exercises. That's it for now!

__May-2013__: added more course content and better resolution (100dpi) for all plots.

__Apr-2013__: added a lot of course content and cleaner plots. Also adding the [R-2013-Lyon](R-2013-Lyon) folder for a conference presentation on the course.

__Mar-2013__: reviewed course structure: less files, more code, tons of new examples and exercises.

__Feb-2013__: more efficient `.Rprofile` functions and improved `knitr` routine, tidier code on the early sessions.

__Jan-2013__: first release.

> First release: January 2013.  
> Last revised: August 2013.
