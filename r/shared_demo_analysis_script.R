# This script contains a shared demo analysis
# That we will try running in Google Compute Engine
# And on UCSB servers

# Load packages

library(tidyverse) # for dplyr, purr functions
library(furrr) # For parallel processing
library(tictoc) # For keeping track of how long things take

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