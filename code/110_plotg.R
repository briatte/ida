plotg <- function(net, value=NULL) {
  m <- as.matrix.network.adjacency(net) # get sociomatrix
  # get coordinates from Fruchterman and Reingold's force-directed placement algorithm.
  plotcord <- data.frame(gplot.layout.fruchtermanreingold(m, NULL)) 
  # or get it them from Kamada-Kawai's algorithm: 
  # plotcord <- data.frame(gplot.layout.kamadakawai(m, NULL)) 
  colnames(plotcord) = c("X1","X2")
  edglist <- as.matrix.network.edgelist(net)
  edges <- data.frame(plotcord[edglist[,1],], plotcord[edglist[,2],])
  plotcord$elements <- as.factor(get.vertex.attribute(net, "elements"))
  colnames(edges) <-  c("X1","Y1","X2","Y2")
  #   edges$midX  <- (edges$X1 + edges$X2) / 2
  #   edges$midY  <- (edges$Y1 + edges$Y2) / 2
  pnet <- ggplot()  + 
    geom_segment(aes(x=X1, y=Y1, xend = X2, yend = Y2), 
                 data=edges, size = 0.5, colour="grey") +
    geom_point(aes(X1, X2,colour=elements), data=plotcord) +
    scale_colour_brewer(palette="Set1") +
    scale_x_continuous(breaks = NULL) + scale_y_continuous(breaks = NULL) +
    # discard default grid + titles in ggplot2 
    opts(panel.background = theme_blank()) + opts(legend.position="none")+
    opts(axis.title.x = theme_blank(), axis.title.y = theme_blank()) +
    opts(legend.background = theme_rect(colour = NA)) + 
    opts(panel.background = theme_rect(fill = "white", colour = NA)) + 
    opts(panel.grid.minor = theme_blank(), panel.grid.major = theme_blank())
  return(print(pnet))
}
