# This script takes the values that have been screened for quality
# Anna Boser
# May 19

library(data.table)
library(here)
library(dplyr)

good <- fread(here("data/ECOSTRESS/int/file_names.csv"))
good <- filter(good, consensus == 2) # keep only full images that are cloud-free over the hills not over the bay
good <- good$file

dir.create(here("data", "ECOSTRESS", "int", "celcius_approved"))

file.copy(from=here("data", "ECOSTRESS", "int", "celcius", good), 
          to=here("data", "ECOSTRESS", "int", "celcius_approved"), 
          overwrite = TRUE, recursive = FALSE, 
          copy.mode = TRUE)
