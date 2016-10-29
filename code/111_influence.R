

# Load packages.
packages <- c("downloader", "intergraph", "GGally", "ggplot2", "network", "RColorBrewer", "sna")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Locate and save the network data.
net = "data/network.tsv"
ids = "data/nodes.tsv"
zip = "data/twitter.an.zip"
if(!file.exists(zip)) {
  download("https://raw.github.com/briatte/ggnet/master/network.tsv", net)
  download("https://raw.github.com/briatte/ggnet/master/nodes.tsv", ids)
  zip(zip, file = c(net, ids))
  file.remove(net, ids)
}
# Get data on current French MPs.
ids = read.csv(unz(zip, ids), sep = "\t")
# Get data on their Twitter accounts.
net = read.csv(unz(zip, net), sep = "\t")
# Copy network data for later use.
ndf = net
# Convert it to a network object.
net = network(net)



mps = data.frame(Twitter = network.vertex.names(net))
# Set the French MP part colours.
mp.groups = merge(mps, ids, by = "Twitter")$Groupe
mp.colors = brewer.pal(9, "Set1")[c(3, 1, 9, 6, 8, 5, 2)]
# First ggnet example plot.
ggnet(net, 
      weight = "degree", 
      quantize = TRUE,
      node.group = mp.groups, 
      node.color = mp.colors,
      names = c("Group", "Links")) + 
  theme(text = element_text(size = 16))



# Recall network data structure.
head(ndf)
# Load network functions.
code = "https://raw.github.com/briatte/ggnet/master/functions.R"
downloader::source_url(code, prompt = FALSE)
# A few simple examples.
x = who.follows(ndf, "nk_m")
y = who.is.followed.by(ndf, "JacquesBompard")
# A more subtle measure.
lapply(levels(ids$Groupe), top.group.outlinks, net = ndf)



# Calculate network betweenness.
top.mps = order(betweenness(net), decreasing = TRUE)
# Get the names of the vertices.
top.mps = cbind(top.mps, network.vertex.names(net)[top.mps])
# Show the top 5.
head(top.mps)


