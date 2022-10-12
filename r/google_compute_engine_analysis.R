# This script contains a shared demo analysis
# That we will try running in Google Compute Engine
# And on UCSB servers

# Load packages

library(tidyverse) # for dplyr, purr functions
library(furrr) # For parallel processing
library(tictoc) # For keeping track of how long things take
library(googleCloudStorageR) # For working with data in Google Cloud Storage

# We can double-check our number of cores
number_cores <- parallel::detectCores()

number_cores

# If you want to monitor your CPU and memory usage, you can install the htop tool
# Run these lines in terminal of your R Studio server in your browser:
# sudo apt update && sudo apt upgrade
# sudo apt install htop
# htop

# Define arbitrary function for testing parallel processing
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

# Now let's run this 8 times in a row and see how long it takes
tic()
rep(1,8) %>%
  map(my_long_function)
toc()

# Now let's try this in parallel

# Set up parallel processing
plan(multisession,
     workers = parallel::detectCores())

# Now let's do what we did before, but in parallel
# We can simply replace purrr::map with purrr::future_map
tic()
rep(1,8) %>%
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

# Authenticate GCS
# This uses the same credentials and GCP
# Make sure to save .httr-oauth
gcs_auth()

# List all files in the "upsides" bucket
# Ensure the GCS bucket's region is the same region as the GCE VM - this will help ensure it runs as fast as possible
gcs_list_objects(bucket = "upsides")

# You can also set a "global" default bucket if you want, using gcs_global_bucket("upsides")
# But we'll explicitly call it out in the following

# Now load the data into R

upsides_data <- gcs_get_object(object_name = "Unlumped_ProjectionData.csv", 
                               bucket = "upsides")

# Alternatively, you can save it to your VM
# gcs_get_object(object_name = "Unlumped_ProjectionData.csv", bucket = "upsides", saveToDisk = "upsides/Unlumped_ProjectionData.csv")

upsides_data

# Now we can manipulate the data, and re-upload it to GCS
# As an example, let's create a new object that is just the first 100 rows
upsides_data_sliced <- upsides_data %>% 
  slice(1:100)

gcs_upload(file = upsides_data_sliced,
           bucket = "upsides",
           name = "upsides_data_sliced.csv")

# List all files in the bucket
gcs_list_objects(bucket = "upsides")

# To clean things up, we can delete this
gcs_delete_object(object_name = "upsides_data_sliced.csv",
                  bucket = "upsides")
