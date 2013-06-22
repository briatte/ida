

# Load packages.
packages <- c("downloader", "network", "sna")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Set network size.
n = 30
# Create n series of n.
ego = rep(1:n, each = n)
# Create n sequences of n.
alter = rep(1:n, times = n)
# Default to no friendship between ego and alter.
friendship = 0
# Assemble dataset.
rnet = data.frame(ego, alter, friendship)
# First rows.
head(rnet)



# Probability of friendship tie.
conDen <- .15
# Assign ties to random nodes.
for (i in 1:n)
  for (ii in (i+1):n)
    if ((rbinom(1, 1, conDen) == 1) & (i != ii)) {
      rnet$friendship[(rnet$ego ==i  & rnet$alter == ii)] = 1
      rnet$friendship[(rnet$ego ==ii & rnet$alter == i )] = 1
      }
# Inspect random network ties.
summary(rnet)



# Form network object.
net = network(rnet[rnet$friendship == 1, ], directed = FALSE)
net
# Load ggnet function.
code = "https://raw.github.com/briatte/ggnet/master/ggnet.R"
downloader::source_url(code, prompt = FALSE)
# Plot random network.
ggnet(net,
      label = TRUE,
      color = "white")



# Locate data.
link = "http://www.babelgraph.org/data/ga_edgelist.csv"
file = "data/ga.network.txt"
# Download data.
if(!file.exists(file)) download(link, file, mode = "wb")
# Create network.
net = network(read.csv(file), directed = FALSE)
# Load ggnet function.
code = "https://raw.github.com/briatte/ggnet/master/ggnet.R"
downloader::source_url(code, prompt = FALSE)
# Plot network.
ggnet(net, 
      label = TRUE, 
      color = "white", 
      top8 = TRUE, 
      size = 18,
      legend.position = "none")


