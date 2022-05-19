# convert the files to air temperature
# Anna Boser
# May 19

library(here)
library(raster)

regression <- readRDS(file = here::here("data", 
                                        "ECOSTRESS",
                                        "int", 
                                        "regression.RDS"))

dir.create(here::here("data", 
                      "ECOSTRESS",
                      "int",
                      "air_temp"))

to_air_temp <- function(file){
  print(file)
  T <- raster(here::here("data", 
                         "ECOSTRESS",
                         "int",
                         "celcius_approved", 
                         file))
  
  ones <- T
  ones[] <- 1 #make a raster of ones
  
  # correct temperature
  T <- regression[["coefficients"]][[1]]*ones + 
    regression[["coefficients"]][[2]]*T + 
    regression[["coefficients"]][[3]]*(T^2) + 
    regression[["coefficients"]][[4]]*(T^3)
  
  writeRaster(T, here::here("data", 
                            "ECOSTRESS",
                            "int",
                            "air_temp", 
                            file), 
              overwrite=TRUE)
}

files <- list.files(here::here("data", 
                               "ECOSTRESS",
                               "int",
                               "celcius_approved"))

lapply(files, to_air_temp)


# plot one air temperature file
library(ggplot2)
r <- raster(here("data/ECOSTRESS/int/air_temp/lst_00:13:38_2021_05_26.tif"))
plot_with_name <- function(raster){
  print(plot(raster, 
             col = pal(50), 
             main=names(raster), 
             zlim=c(0, 60)))
}
plot_with_name(r)
