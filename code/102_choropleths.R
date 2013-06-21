

packages <- c("downloader", "ggplot2", "maps", "RColorBrewer", "scales", "XML")
packages <- lapply(packages, FUN = function(x) {
  if(!require(x, character.only = TRUE)) {
    install.packages(x)
    library(x, character.only = TRUE)
  }
})



# David Wasserman's data.
link = "https://docs.google.com/spreadsheet/pub?key=0AjYj9mXElO_QdHpla01oWE1jOFZRbnhJZkZpVFNKeVE&gid=0&output=csv"
# Download the spreadsheet.
if(!file.exists(file <- "data/wasserman.votes.0812.txt")) download(link, file, mode = "wb")
# Import selected rows.
dw <- read.csv(file, stringsAsFactors = FALSE, skip = 4)[-c(1:6, 19:20, 28), -c(4, 7:8)]
# Check result.
str(dw)



# Fix dots in names.
names(dw) <- gsub("\\.\\.", "", names(dw))
# Remove characters.
dw <- data.frame(gsub("\\*|,|%", "", as.matrix(dw)), stringsAsFactors = FALSE)
# Make data numeric.
dw[, -1] <- data.matrix(dw[, -1])
# Create marker for swing states.
dw$Swing <- FALSE
# Mark first twelve states.
dw$Swing[1:12] <- TRUE
# Check result.
dw[1:15, ]



# Obama victory margins, using two-party vote.
dw  <- within(dw, {
  State_Color <- ifelse(Obama08 > McCain08, "Blue", "Red")
  # Margin in 2008.
  Total_VS_08 <- Obama08 + McCain08
  Obama_VS_08 <- 100 * Obama08 / Total_VS_08
  # Margin in 2012.
  Total_VS_12 <- Obama12 + Romney12
  Obama_VS_12 <- 100 * Obama12 / Total_VS_12
  # Obama swing in two-party vote share.
  Obama_Swing <- Obama_VS_12 - Obama_VS_08
  # Swing required for state to change hands.
  Rep_Wins <- 100 * (Romney12 - Obama12) / Total_VS_12
})
# Check results.
str(dw)



# Order plot by states.
dw$State <- with(dw, reorder(State, Obama_Swing), ordered = TRUE)
# Dot plot.
ggplot(dw, aes(y = State, x = Obama_Swing)) +
  geom_vline(x = c(0, mean(dw$Obama_Swing)), size = 4, color = "grey95") +
  geom_point(aes(colour = ifelse(Obama08 > McCain08, "Dem", "Rep")), size = 5) +
  geom_point(data = subset(dw, Swing), aes(x = Rep_Wins), size = 5, shape = 1) +
  scale_x_continuous(breaks = -10:4) +
  scale_colour_manual("2008", values = brewer.pal(3, "Set1")[c(2, 1)]) +
  labs(y = NULL, x = NULL, title = "Obama Swing in Two Party Vote Share\n")



# Electoral college votes, 2012.
url = "http://en.wikipedia.org/wiki/Electoral_College_(United_States)"
# Extract fifth table.
college <- readHTMLTable(url, which = 5, stringsAsFactors = FALSE)
# Keep first and last columns, removing total electors.
college <- data.frame(State = college[, 1], 
                      College = as.numeric(college[, 35]))
# Merge to main dataset.
dw <- merge(dw, college, by = "State")
# U.S. states codes.
url = "http://en.wikipedia.org/wiki/List_of_U.S._states"
# Extract fifth table.
uscodes <- readHTMLTable(url, which = 2, stringsAsFactors = FALSE)
# Keep first and last columns, removing total electors.
uscodes <- data.frame(State = uscodes[, 1],
                      Abbreviation = uscodes[, 4])
# Merge to main dataset.
dw <- merge(dw, uscodes, by = "State")
# Check result.
str(dw)



# Swing vs. Vote Share, weighted by Electoral College Votes.
ggplot(dw, aes(y = Obama_Swing, x = Obama_VS_08)) +
  geom_rect(xmin = 50, xmax = Inf, ymin = -Inf, ymax = Inf,
            alpha = .3, fill = "grey95") +
  geom_point(aes(color = Romney12 > Obama12, size = College), alpha = .6) +
  geom_text(colour = "white", 
            label = ifelse(dw$Swing, as.character(dw$Abbreviation), NA)) +
  scale_colour_manual("2008", values = brewer.pal(3, "Set1")[c(2, 1)]) +
  scale_size_area(max_size = 42) +
  labs(y = "Obama Swing in Two Party Vote Share", x = "Obama 2008 Vote Share") +
  theme(legend.position = "none")



# Load state shapefile from maps.
states.data <- map("state", plot = FALSE, fill = TRUE)
# Convert shapes to a data frame.
states.data <- fortify(states.data)
# Extract states from data frame.
states.list <- sort(unique(states.data$region))
# Exclude Washington D.C. (sorry).
states.list = states.list[-which(grepl("columbia", states.list))]
# Subset to map states (sorry Alaska).
dw = subset(dw, tolower(State) %in% states.list)
# Transpose data to map dataset.
states.data$SwingBO <- by(dw$Obama_Swing, states.list, mean)[states.data$region]
states.data$Obama08 <- by(dw$Obama_VS_08, states.list, mean)[states.data$region]
states.data$Obama12 <- by(dw$Obama_VS_12, states.list, mean)[states.data$region]



# Prepare quintile function.
quantize <- function(x, q = 5) {
  return(cut(x, breaks = quantile(round(x), probs = 0:q/q, na.rm = TRUE), 
      include.lowest = TRUE))
}
# Common map elements.
g <- ggplot(states.data, aes(x = long, y = lat, group = group)) +
  geom_polygon(colour = "white") + coord_map(project = "conic", lat0 = 30) +
  scale_fill_brewer("", palette = "RdYlBu") +
  labs(y = NULL, x = NULL) +
  theme(panel.border = element_rect(color = "white"), 
        axis.text = element_blank(),
        axis.ticks = element_blank())



# Choropleth maps.
g + aes(fill = quantize(SwingBO)) + ggtitle("Swing in the Obama vote share")
g + aes(fill = quantize(Obama08)) + ggtitle("Obama vote share, 2008")
g + aes(fill = quantize(Obama12)) + ggtitle("Obama vote share, 2012")


