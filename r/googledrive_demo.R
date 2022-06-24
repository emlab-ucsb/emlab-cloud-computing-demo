library(googledrive)
library(tidyverse)
# Say we want to read in the "upsides" database,
# Which is on the team drive at: emlab/data/upsides/Unlumped_ProjectionData.csv
# On our computer, we navigate to that file, and copy the google drive link of the file


# The link is: https://drive.google.com/open?id=1-tklB_HWWCShvKZXW8GTrsOXoPf0pm2n&authuser=gmcdonald%40ucsb.edu&usp=drive_fs
# The file id is therefore: 1-tklB_HWWCShvKZXW8GTrsOXoPf0pm2n

# Let's download the file to a temporary location
temp_file_name <- tempfile()

# When you fist run this, you will need to authenticate
# Using your ucsb google account
drive_get(id="1-tklB_HWWCShvKZXW8GTrsOXoPf0pm2n") %>%
  drive_download(type = "csv",
                 path = temp_file_name)

# Now we read it in from the temporary location using read_csv
# This will load the file in our environment
upsides_data <- temp_file_name %>%
  read_csv()
