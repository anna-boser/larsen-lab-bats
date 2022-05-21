# convert the air temperature brick to a trait brick 
# and save both the brick and the average

library(raster)
library(here)

new_path <- here::here("data", 
                       "ECOSTRESS",
                       "for_analysis")
dir.create(new_path)

brick <- brick(here::here("data", 
                          "ECOSTRESS",
                          "int", 
                          "air_temp_brick.tif"))

to_trait <- function(trait_function, traitname){
  # apply trait function
  brick <- trait_function(brick)
  # save brick
  writeRaster(brick, 
              here::here(new_path, 
                         paste0(traitname, "_brick.tif")),
              bylayer = FALSE, 
              overwrite = TRUE)
  # save the mean
  mean <- mean(brick)
  writeRaster(mean, 
              here::here(new_path, 
                         paste0(traitname, ".tif")),
              bylayer = FALSE, 
              overwrite = TRUE)
}

# trait functions
air_temp <- function(T){
  T
}

transmit <- function(T){
  -(2.94*10^-3) * T * (T - 11.3) * (T - 41.9)
}

bite <- function(T){
  bite <- (1.67*10^-4) * T * (T- 2.3) * (32.0 - T)^(1/2)
  bite <- ifelse(is.nan(bite), 0, bite)
  return(bite)
}

# apply trait functions
to_trait(air_temp, "air_temp")
to_trait(transmit, "transmission")
to_trait(bite, "biting_rate")
