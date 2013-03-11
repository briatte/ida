

# Load packages.
require(downloader)
require(foreign)

# Download QOG codebook.
if(!file.exists(file <- "data/qog_codebook.pdf"))
  download("http://www.qogdata.pol.gu.se/codebook/codebook_standard_20110406.pdf", file)

# Download QOG data.
if(!file.exists(file <- "data/qog_cs.dta")) {
  download("http://www.qogdata.pol.gu.se/data/qog_std_cs.dta", file)
}

# Import.
qog.d <- read.dta(file)

# Check result.
names(qog.d)


