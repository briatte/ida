

# Load packages.
packages <- c("downloader", "ggplot2", "network", "RColorBrewer")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# Load ggnet function.
code = "https://raw.github.com/briatte/ggnet/master/ggnet.R"
downloader::source_url(code, prompt = FALSE)



# Data download-and-load function.
ggnet.data = function(file) {
  link = paste0("https://raw.github.com/briatte/ggnet/master/", file)
  data = paste0("data/frmps.", file)
  if(!file.exists(data)) download(link, data, mode = "wb")
  data = read.csv(data, sep = "\t")
  print(head(data))
  return(data)
}
# Get French MPs on Twitter data.
ids <- ggnet.data("nodes.txt")
df  <- ggnet.data("network.txt")
# Convert it to a network object.
net = network(df)



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



# Load functions.
code = "https://raw.github.com/briatte/ggnet/master/functions.R"
downloader::source_url(code, prompt = FALSE)
# A few simple examples.
x = who.follows(df, "nk_m")
y = who.is.followed.by(df, "JacquesBompard")
# A more subtle measure.
lapply(levels(ids$Groupe), top.group.outlinks, net = df)



# Calculate network betweenness.
top.mps = order(betweenness(net), decreasing = TRUE)
# Get the names of the vertices.
top.mps = cbind(top.mps, network.vertex.names(net)[top.mps])
# Show the top 5.
head(top.mps)


