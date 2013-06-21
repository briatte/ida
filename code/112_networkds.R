

packages <- c("downloader", "ggplot2", "network", "tm")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



build.corpus <- function(x, skip = 0) {
  # Read the text source.
  src = scan(x, what = "char", sep = "\n", encoding = "UTF-8", skip = skip)
  # Extract all words.
  txt = unlist(strsplit(gsub("[[:punct:]]", " ", tolower(src)), "[[:space:]]+"))
  # Function to create word nodes.
  associate <- function(x) {
    y = c(txt[x], txt[x + 1])
    if(!TRUE %in% (y %in% c("", stopwords("en")))) y
    }
  # Build word network.
  net = do.call(rbind, sapply(1:(length(txt) - 1), associate))
  # Return network object.
  return(network(net))
}
# Example data.
net = build.corpus("data/assange.txt")



# Load ggnet function.
code = "https://raw.github.com/briatte/ggnet/master/ggnet.R"
source_url(code, prompt = FALSE)
# Plot with ggnet.
ggnet(net, weight = "degree", subset = 3,
      alpha = 1, segment.color = "grey", label = TRUE, vjust = - 2,
      legend = "none")



# Target locations
link = "https://raw.github.com/jwise/28c3-doctorow/master/transcript.md"
file = "data/doctorow.txt"
# Download speech.
if(!file.exists(file)) download(link, file)
# Build corpus.
net = build.corpus(file, skip = 37)
# Plot with ggnet.
ggnet(net, weight = "degree", subset = 3,
      alpha = 1, segment.color = "grey", label = TRUE, vjust = - 2,
      legend = "none")


