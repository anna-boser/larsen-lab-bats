# This script changes the raw ECOSTRESS files to Celcius, renames them, and saves them in
# Anna Boser 
# May 9 2022

library(raster)
library(here)
library(parallel)
library(stringr)
library(lubridate)

raw_folder <- here::here("data", "ECOSTRESS", "raw")
new_folder <- here::here("data", "ECOSTRESS", "int", "celcius")

if (!dir.exists(new_folder)){
    dir.create(new_folder, recursive = TRUE)
}

# list of files to be converted: 
files <- list.files(path = raw_folder, 
                    pattern = "tif", 
                    recursive = TRUE, 
                    full.names = TRUE)

# function to change files to celcius and save under new name in the new data folder
celcius <- function(file){

  # read the raster

  raster <- raster(file)
  print(paste("file read in:", file))

  # change to celcius

  raster <- raster*.02 - 273.15
  print("converted to celcius")

  # rename 

  nums <- str_extract(file, regex('(?<=doy)[0-9]+'))
  year <- substr(nums, 1, 4)
  doy <- substr(nums, 5, 7) %>% as.numeric()
  hhmmss <- substr(nums, 8, 13)
  date <- as.Date(doy - 1, origin = paste0(year, "-01-01"))
  dt <- ymd_hms(paste(date, hhmmss), tz = "UTC") %>% with_tz("America/Los_Angeles")
  month <- format(dt,"%m")
  hour <- hour(dt)
  day <- format(dt,"%d")
  time <- substr(dt, 12, 19)
  
  name <- paste0("lst", "_", time, "_", year, "_", month, "_", day, ".tif")

  # save raster in calcius under new name

  writeRaster(raster, file.path(new_folder, name), overwrite = TRUE)
  print(paste0("file saved:", name))
}

# run this function in parallel

no_cores <- detectCores()# Calculate the number of cores
print(no_cores)
cl <- makeCluster(no_cores, type="FORK") # Initiate cluster
parLapply(cl, files, celcius)
stopCluster(cl)

# also save a file list in the form of a .csv of the output files
file <- list.files(path = new_folder, 
                    pattern = "tif", 
                    recursive = TRUE)

df <- as.data.frame(file)

write.csv(df, file.path(new_folder, "file_names.csv"))