

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


