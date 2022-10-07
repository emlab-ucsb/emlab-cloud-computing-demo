# Load packages

library(googleComputeEngineR)

# First, follow setup instructions for downloading json and editing .Renviron
# https://cloudyr.github.io/googleComputeEngineR/articles/installation-and-authentication.html

# Let's look at the VMs currently running
gce_list_instances()

# Create an RStudio Server on Google Compute Engine
# Following: https://cloudyr.github.io/googleComputeEngineR/articles/creating-vms.html

# Give your VM a name
vm_name <- "gmcdonald-rstudio-server"

# Create and start a VM with your desired specifications
gce_vm(name = vm_name, 
       cpus = 8, # Specify the number of cores
       memory = 32000, # Specify how much RAM you need, in MB
       disk_size_gb = 10, # Specify how big a hard drive you need, in GB
       template = "rstudio", # This is a standard rstudio install with tidyverse packages
       username = "gmcdonald", 
       password = "1234")

# As a more advance option, you may create a "Persistent" RStudio on Google Compute Engine
# Following https://cloudyr.github.io/googleComputeEngineR/articles/persistent-rstudio.html

# Now let's look at the instance list
gce_list_instances()

# We can also look at the GUI in our web browser: https://console.cloud.google.com/compute

# Look at the external IP address of your VM
gce_get_external_ip(vm_name)

# Navigate browser to {external_ip}:80 to view your server

# Clone GitHub repo: https://github.com/emlab-ucsb/emlab-cloud-computing-demo
# try google_compute_engine_analysis.r

# Let's stop it
# Remember, Google charges by the hour
# So always stop your VMs when not in use
gce_vm_stop(vm_name)

# And delete it if you won't be needing it again
gce_vm_delete(vm_name)

# Now let's look at the instance list again to make sure it was deleted
gce_list_instances()

# Some helpful links on setup, and why Google Cloud Storage may be better
# than using Google Drive with FUSE
# https://cloudyr.github.io/googleComputeEngineR/articles/persistent-rstudio.html
# https://github.com/cloudyr/googleComputeEngineR/issues/118
# https://github.com/cloudyr/googleComputeEngineR/issues/109