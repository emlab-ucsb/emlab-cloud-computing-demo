# This script contains a shared demo analysis
# That we will try running in Google Compute Engine
# And on UCSB servers

# Load packages

library(tidyverse) # for dplyr, purr functions
library(furrr) # For parallel processing
library(tictoc) # For keeping track of how long things take
library(googleCloudStorageR) # For working with data in Google Cloud Storage

# First, let's install the htop tool so you can monitor your CPU usage
# Run these lines in terminal of your R Studio server in your browser:
# sudo apt update && sudo apt upgrade
# sudo apt install htop
# htop

# We can double-check our number of cores
number_cores <- parallel::detectCores()

number_cores

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

# Say we want to read in the "upsides" database
# Which is on the team drive at: emlab/data/upsides/Unlumped_ProjectionData.csv

# Approach 1 - Manually upload
# We could simply upload this file through the GUI

# Approach 2 - Google Cloud Storage
# You can work with data stored on Google Cloud Storage: https://console.cloud.google.com/storage
# Here's a nice tutorial: https://hydroecology.net/computing-in-the-cloud-with-google-and-rstudio/

# Authenticate GCS - Click 1/yes to store .httr-oauth credentials
gcs_auth()

# Set default bucket
# Ensure the GCS bucket's region is the same region as the GCE VM
gcs_global_bucket("upsides")

# List all files in the bucket
gcs_list_objects()

# Now load the data into R
upsides_data <- gcs_get_object("Unlumped_ProjectionData.csv")

upsides_data

# Now we can manipulate the data, and re-upload it to GCS
# As an example, let's create a new object that is just the first 100 rows
upsides_data_sliced <- upsides_data %>% 
  slice(1:100)

gcs_upload(upsides_data_sliced,
           name = "upsides_data_sliced.csv")

# List all files in the bucket
gcs_list_objects()

# To clean things up, we can delete this
gcs_delete_object("upsides_data_sliced.csv")