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
  transmit <- -(2.94*10^-3) * T * (T - 11.3) * (T - 41.9)
  transmit <- ifelse(transmit<0, 0, transmit)
  return(transmit)
}

bite <- function(T){
  bite <- (1.67*10^-4) * T * (T- 2.3) * (32.0 - T)^(1/2)
  bite <- ifelse(is.nan(bite), 0, bite)
  return(bite)
}

mdr <- function(T){
  mdr <- (4.12*10^-5) * T * (T - 4.3) * (39.9 - T)^(1/2)
  mdr <- ifelse(is.nan(mdr), 0, mdr)
  return(mdr)
} 

# this is for Cx. Pipiens since tarsalis is not available
fecundity <- function(T){
  fecundity <- -(5.98*10^-1) * T * (T - 5.3) * (T - 38.9)
  fecundity <- ifelse(fecundity<0, 0, fecundity)
  return(fecundity)
}

immature_survival <- function(T){
  immature_survival <- -(2.12*10^-3) * T * (T - 5.9) * (T - 43.1)
  immature_survival <- ifelse(immature_survival<0, 0, immature_survival)
  return(immature_survival)
}

# lifespan. used Cx. annulirostris
lf <- function(T){
  lf <- -(2.42*10^-1) * T * (T - 13.1) * (T - 33.6)
  lf <- ifelse(lf<0, 0, lf)
  return(lf)
}

adult <- function(T){
  (fecundity(T) * immature_survival(T) * mdr(T))/(lf(T)^-2)
}

# apply trait functions
to_trait(air_temp, "air_temp")
to_trait(transmit, "transmission")
to_trait(bite, "biting_rate")
to_trait(adult, "adult_abundance")
