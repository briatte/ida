#' If you like [this approach][1] to correlation matrixes, you might also like
#' the `arm::corrplot` function. Here's a ggplot2 implementation.
#' [1]: http://stackoverflow.com/questions/12196756/significance-level-added-to-matrix-correlation-heatmap-using-ggplot2

ggcorr <- function(x, method = "pairwise", palette = "RdYlGn") {
  require(ggplot2)
  require(reshape) # edit when reshape2 reaches maturity

  M <- cor(x[1:ncol(x)], use = method)
  M <- M * lower.tri(M)
  M <- as.data.frame(M)
  M <- data.frame(row = names(x), M)
  M <- suppressMessages(melt(M))
  M$value[M$value == 0] <- NA
  s <- seq(-1, 1, by = .25)
  M$value <- cut(M$value, breaks = s, include.lowest = TRUE,
                 label = cut(s, breaks = s)[-1])
  M$row <- factor(M$row, levels = (unique(as.character(M$variable))))
  diag <- subset(M, row == variable)
  
  po.nopanel <- list(theme(
    panel.background = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank(),
    axis.text.x = element_text(angle = -90)))
  
  ggplot(M, aes(row, variable)) + 
    scale_fill_brewer(palette = palette, name = "Correlation\ncoefficient") +
    geom_tile(aes(fill = value), colour = "white") +
    geom_text(data = diag, aes(label = variable, hjust = 1), size = 4) +
    scale_x_discrete(breaks = NULL) + scale_y_discrete(breaks = NULL) +
    labs(x = "", y = "") + po.nopanel
}

#' Example below (not run).
#' nba <- read.csv("http://datasets.flowingdata.com/ppg2008.csv")
#' ggcorr(nba[-1])
#' 
#' ~ François, March 2013
#' 