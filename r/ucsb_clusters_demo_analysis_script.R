# This script is almost the same as the shared_demo_analysis_script.R
# The only difference is line 61 - non-interactive authentication for google drive
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

# The link is: https://drive.google.com/open?id=1-tklB_HWWCShvKZXW8GTrsOXoPf0pm2n&authuser=gmcdonald%40ucsb.edu&usp=drive_fs
# The file id is therefore: 1-tklB_HWWCShvKZXW8GTrsOXoPf0pm2n

# Let's download the file to a temporary location
temp_file_name <- tempfile()

# Authenticate using a Service Account token for non-interactive authentication
drive_auth(path = file.path(here::here(), "emlab-gcp-d0cfcb1eaee0.json"))


drive_get(id="1qmKT1QHNk9sFEzAWFaicKaJTGi4k079p") %>%
  drive_download(path = temp_file_name) # Should run without asking for authentication

# Now we read it in from the temporary location using read_csv
# This will load the file in our environment
upsides_data <- temp_file_name %>%
  read_csv()

upsides_data

