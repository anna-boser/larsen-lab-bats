
library(raster)
library(here)
library(ggplot2)

m_abundance <- raster("data/ECOSTRESS/for_analysis/adult_abundance.tif")
m_abundance <- as.data.frame(m_abundance, xy=TRUE)

ggplot() + 
  geom_raster(data = m_abundance, aes(x=x, y=y, fill=adult_abundance)) + 
  ggtitle("") + 
  xlab("") + 
  ylab("") +
  scale_fill_distiller(palette="Spectral", direction = 1, name = "Mosquito abundance") + 
  theme_bw()