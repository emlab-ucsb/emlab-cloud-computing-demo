library(googleComputeEngineR)

# Create a Persistent RStudio on Google Compute Engine
# Following https://cloudyr.github.io/googleComputeEngineR/articles/persistent-rstudio.html

# Give your VM a name
vm_name <- "gavin-rstudio-server-test"

# n2-standard-8 has 8 cores and 32 GB of RAM
gce_vm(name = vm_name, 
       predefined_type = "n2-standard-8", 
       template = "rstudio", 
       username = "gmcdonald", 
       password = "1234", 
       disk_size_gb = 10)

gce_get_external_ip(vm_name)

# Navigate browser to {external_ip}:80

# Clone GitHub repo, try shared_demo_analysis_script.R

# Let's stop and delete it
gce_vm_stop(vm_name)

gce_vm_delete(vm_name)
