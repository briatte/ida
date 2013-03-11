

source("code/3_browsers.R")



# Time series.
ggplot(melt, aes(x = Date)) + labs(y = "", x = "") + theme_bw(16) +
  geom_smooth(aes(y = value, color = Browser, fill = Browser), alpha = .2) + 
  geom_smooth(aes(y = HHI, linetype = "HHI"), HHI, se = FALSE, color = "black") +
  scale_linetype_manual(name = "Market\nconcentration", values = c("HHI" = "dashed"))


