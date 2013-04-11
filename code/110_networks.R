

require(igraph)



# Set network size.
n <- 30
# Create n series of n.
ego <- rep(1:n,each=n)
# Create n sequences of n.
alter <- rep(1:n,times=n)
# Default to no friendship between ego and alter.
friendship <- 0
# Assemble dataset.
rnet <- data.frame(ego, alter, friendship)



head(rnet)



conDen <- .15
for (i in 1:n)
  for (ii in (i+1):n)
    if ((rbinom(1,1,conDen)==1)&(i!=ii)) {
      # print(paste(i,ii))
      rnet$friendship[(rnet$ego==i & rnet$alter==ii)] <- 1
      rnet$friendship[(rnet$ego==ii & rnet$alter==i)] <- 1
      }



summary(rnet)



plot(graph.data.frame(rnet[rnet$friendship==1,], directed=F), main="Purely Random Connections")



library(network)
library(sna)
library(ergm)
source("code/plotg.r")

n <- 30
g <- network(n, directed=FALSE, density=0.05)
classes <- rbinom(n,1,0.5) + rbinom(n,1,0.5) + rbinom(n,1,0.5)
set.vertex.attribute(g, "elements", classes)

plotg(g)



# Load the "igraph" library
library(igraph)

# (0) Fetch the source files.
if(!file.exists("data/mcfarland"))
  dir.create("data/mcfarland")
if(!file.exists("data/mcfarland/mag_act96.txt"))
  download.file("http://dl.dropbox.com/u/25710348/snaimages/mag_act96.txt",
                "data/mcfarland/mag_act96.txt")
if(!file.exists("data/mcfarland/mag_act97.txt"))
  download.file("http://dl.dropbox.com/u/25710348/snaimages/mag_act97.txt",
                "data/mcfarland/mag_act97.txt")
if(!file.exists("data/mcfarland/mag_act98.txt"))
  download.file("http://dl.dropbox.com/u/25710348/snaimages/mag_act98.txt",
                "data/mcfarland/mag_act98.txt")

# (1) Read in the data files, NA data objects coded as "na" 
magact96 = read.delim("data/mag_act96.txt", na.strings = "na")
magact97 = read.delim("data/mag_act97.txt", na.strings = "na")
magact98 = read.delim("data/mag_act98.txt", na.strings = "na")



library(tm)
# Julian Assange, UN address, September 2012.
# URL: http://wikileaks.org/Transcript-of-Julian-Assange.html
loc <- "data/assange.txt"
txt <- scan(file=loc, what="char", sep="\n", encoding="UTF-8");

words <- unlist(strsplit(gsub("[[:punct:]]", " ", tolower(txt)), "[[:space:]]+"));
g.start <- 1;
g.end <- length(words) - 1;
assocs <- matrix(nrow=g.end, ncol=2)

for (i in g.start:g.end)
{
  assocs[i,1] <- words[i];
  assocs[i,2] <- words[i+1];
#   print(paste("Pass #", i, " of ", g.end, ". ", "Node word is ", toupper(words[i]), ".", sep=""));
}

# Remove associations to common English words.
assocs <- subset(assocs,!(assocs[,1] %in% stopwords("en")))
assocs <- subset(assocs,!(assocs[,2] %in% stopwords("en")))

g.assocs <- graph.data.frame(assocs, directed=F);
V(g.assocs)$label <- V(g.assocs)$name;
V(g.assocs)$color <- "Gray";
V(g.assocs)[unlist(largest.cliques(g.assocs))]$color <- "Red";
plot(g.assocs, layout=layout.random, vertex.size=4, vertex.label.dist=0);
# plot(g.assocs, layout=layout.circle, vertex.size=4, vertex.label.dist=0);
# plot(g.assocs, layout=layout.fruchterman.reingold, vertex.size=4, vertex.label.dist=0);
# plot(g.assocs, layout=layout.kamada.kawai, vertex.size=4, vertex.label.dist=0);

# ... and make pretty: 
# http://rdatamining.wordpress.com/2012/05/17/an-example-of-social-network-analysis-with-r-using-package-igraph/
V(g.assocs)$degree <- degree(g.assocs)



# in progress
# V(g.assocs)$label.cex <- 2.2 * V(g.assocs)$degree / max(V(g.assocs)$degree)+ .2
# V(g.assocs)$label.color <- rgb(0, 0, .2, .8)
# V(g.assocs)$frame.color <- NA
# egam <- (log(E(g.assocs)$weight)+.4) / max(log(E(g.assocs)$weight)+.4)
# E(g.assocs)$color <- rgb(.5, .5, 0, egam)
# E(g.assocs)$width <- egam

# http://www.r-bloggers.com/grey%E2%80%99s-anatomy-network-of-sexual-relations/


