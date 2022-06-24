# Load packages

library(googleComputeEngineR)

# First, follow setup instructions for downloading json and editing .Renviron
# https://cloudyr.github.io/googleComputeEngineR/articles/installation-and-authentication.html

# Let's look at the VMs currently running
gce_list_instances()

# Create a Persistent RStudio on Google Compute Engine
# Following https://cloudyr.github.io/googleComputeEngineR/articles/persistent-rstudio.html

# Give your VM a name
vm_name <- "gavin-rstudio-server-test"

# n2-standard-8 has 8 cores and 32 GB of RAM
gce_vm(name = vm_name, 
       predefined_type = "n2-standard-8", 
       template = "rstudio", # This is a standard rstudio install with tidyverse packages
       username = "gmcdonald", 
       password = "1234", 
       disk_size_gb = 10) # Specify how big a hard drive you need

# Now let's look at the instance list
gce_list_instances()

gce_get_external_ip(vm_name)

# Navigate browser to {external_ip}:80

# Clone GitHub repo, try shared_demo_analysis_script.R

# Let's stop it
# Remember, Google charges by the hour
# So always stop your VMs when not in use
gce_vm_stop(vm_name)

# And delete it if you won't be needing it again
gce_vm_delete(vm_name)

# Now let's look at the instance list again to make sure it was deleted
gce_list_instances()