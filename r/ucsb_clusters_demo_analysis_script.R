# This script runs through the same demo as google_compute_engine_analysis.R
# Designed to run on the UCSB servers

# Load packages

library(tidyverse) # for dplyr, purr functions
library(furrr) # For parallel processing
library(tictoc) # For keeping track of how long things take
library(googledrive) # for accessing files on Team Drive

# Define arbitrary function
# In this case, we'll simply sleep the system for a
# desired amount of time in s (denoted by sleep_time)
my_long_function <- function(sleep_time){
  Sys.sleep(sleep_time)
  return(sleep_time)
}

# Let's see how long this function takes with an input of 1
tic()
my_long_function(1)
toc()

# Now let's run this 5 times in a row and see how long it takes
tic()
rep(1,5) %>%
  map(my_long_function)
toc()

# Now let's try this in parallel

# First, detect the number of cores on your system
number_cores <- parallel::detectCores()

number_cores

# Set up parallel processing
plan(multisession,
     workers = parallel::detectCores())

# Now let's do what we did before, but in parallel
# We can simply replace purrr::map with purrr::future_map
tic()
rep(1,5) %>%
  future_map(my_long_function)
toc()

# Now let's say we also want to use some data from Team Drive

# Say we want to read in the "upsides" database,
# Which is on the team drive at: emlab/data/upsides/Unlumped_ProjectionData.csv

# Approach 1 - Google Drive Package 
# While possible to use the google drive package it's challenging to set it up with proper non-interactive authentication 
# Non-interactive authentication requires a Service Account token, you can read more about it here: https://cloud.google.com/iam/docs/service-accounts 
# And it isn't possible to write data directly to google drive from the clusters using the google drive package 

# Approach 2 - Manually transfer file (recommended - at least for now)
# It isn't easy or intuitive to read and write directly to google drive from the clusters so for now we recommend just using a file manager client 
# like FileZilla or Visual Studio Code to move data back and forth from the cluster to google drive file stream 

# Move the upsides data from google drive to the cluster
# We can setup the cluster's directories to mimic those of google drive (e.g. our project or in this case the shared data drive)
upsides_path <- file.path(here::here(), "data", "upsides", "Unlumped_ProjectionData.csv")

upsides_data <- read_csv(upsides_path)

# Now we can manipulate the data, and save it locally - we can then move it back over to google drive
# As an example, let's create a new object that is just the first 100 rows
upsides_data_sliced <- upsides_data %>% 
  slice(1:100)

# Save locally 
write_csv(upsides_data_sliced, file.path(here::here(), "data", "upsides", "upsides_data_sliced.csv"))



