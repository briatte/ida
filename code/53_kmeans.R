

# Load original data subset.
load("data/qog_b.Rda")
# Reorder the dataset by fertility rate.
qog_hc <- qog_b[order(qog_b$births), ]
# Store country names in row names.
rownames(qog_hc) <- qog_hc$cname
# Remove country codes and names from the matrix.
qog_hc <- qog_hc[, -c(1:2)]



# Create the distance matrix.
d <- dist(qog_hc, method="euclidean")
# Clusters
hfit <- hclust(d, method="ward")
# Plot dendrogram.
plot(hfit)



# Cutting dendrogram into five clusters.
clus5 <- cutree(hfit, 5)
# Plot dendrogram with red borders around the five clusters.
rect.hclust(hfit, k=5, border="red")



# Create a vector of colors for the five clusters.
mypal <- c("#556270", "#4ECDC4", "#1B676B", "#FF6B6B", "#C44D58")
# Fan plot.
plot(as.phylo(hfit), type = "fan", tip.color = mypal[clus5], label.offset = 1)
# Rerun so that the size of the labels represents the (log of the) fertility rate.
plot(as.phylo(hfit), type = "fan", tip.color = mypal[clus5], label.offset = 1,
     cex = log(qog_hc$births, 2.5))



# k-means clustering with five clusters.
hfit2 <- kmeans(qog_hc, 5)
# Cluster plot.
clusplot(qog_hc, hfit2$cluster, color = TRUE, shade = TRUE, labels = 2, lines = 0)
# Describe the hfit matrix.
hfit2


