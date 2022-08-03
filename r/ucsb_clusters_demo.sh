#!/bin/bash
#SBATCH -n 16                # Number of cores, up to 40
#SBATCH -N 1                # Ensure that all cores are on one machine
##SBATCH -t 0-02:00          # Runtime in D-HH:MM, optional (## means the line is not run) 
#SBATCH -p short          # Partition to submit to (options short, largemem, gpu)

module load R/4.0.1 #Load R module
module load gdal #load preset modules (not necessary for this example but gdal module is useful for any spatial data anlysis on the pod)
export R_LIBS_USER=$HOME/apps/R_4.0.1:$ #tell R which folder to look for packages - will likely have to create this folder (apps/R_4.0.1) in your home directory the first time you login
R CMD BATCH --quiet --no-restore --no-save /home/saraorofino/emlab-cloud-computing-demo/r/shared_demo_analysis_script.R # Path to the script you want to run 
