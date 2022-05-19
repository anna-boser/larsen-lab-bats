# resample to the same grid 
# Anna Boser
# May 19, 2022

library(here)
library(raster)

old_path <- here::here("data", 
                       "ECOSTRESS",
                       "int",
                       "air_temp")

new_path <- here::here("data", 
                       "ECOSTRESS",
                       "int",
                       "air_temp_resampled")

dir.create(new_path)

files <- list.files(old_path)

#choose the first raster as your standard raster
resample_raster <- raster(here(old_path, files[[1]]))

# resample and save using nearest neighbor
resample_save <- function(file){
  print(file)
  r <- raster(here(old_path, file))
  r <- resample(r, resample_raster, "ngb")
  writeRaster(r, here(new_path, file), overwrite=TRUE)
}

lapply(files, resample_save)


# plot one air temperature file
library(ggplot2)
r <- raster(here(new_path, file[[1]]))
plot_with_name <- function(raster){
  print(plot(raster, 
             col = pal(50), 
             main=names(raster), 
             zlim=c(0, 60)))
}
plot_with_name(r)

# make a rasterbrick
rasters <- lapply(here(new_path, files), raster)
rasterbrick <- brick(rasters)
writeRaster(rasterbrick, 
            here::here("data", 
                       "ECOSTRESS",
                       "int", 
                       "air_temp_brick.tif"),
            bylayer = FALSE)