

# Load original data subset.
load("data/qog_b.Rda")
# Reorder the dataset by fertility rate.
qog_pca <- qog_b[order(qog_b$births), ]
# Store country names in row names.
rownames(qog_pca) <- qog_pca$cname
# Remove country codes and names from the matrix.
qog_pca <- qog_pca[, -c(1:2)]
# Compute principal components from the correlation matrix.
fit <- princomp(qog_pca, cor = TRUE)



# Screeplot: components below one criterion are not useful for reduction.
plot(fit, type="l")



# Compute principal components via SVD.
fit2 <- prcomp(qog_pca, scale = TRUE)
# Biplot.
biplot(fit2)



# Loadings: principal components decomposed for each variable.
loadings(fit)


