#!/bin/bash
#SBATCH --qos=xfer
#SBATCH --time=48:00:00
#SBATCH --job-name=transfer_1
#SBATCH --mem=20GB
#SBATCH -A m3562
#SBATCH -e slurm-%j.err
#SBATCH -o slurm-%j.out
cd /global/cscratch1/sd/medha_dg/
#hsi "cd /home/projects/m3562/swissfel_201910/data; get -pR PSI_70ns"
#hsi "cd /home/projects/m3562/swissfel_201910/data; get -pR PSI_dark"
#hsi "cd /home/projects/m3562/swissfel_201910/data; get -pR psI_sample1"
hsi "cd /home/projects/m3562/swissfel_201910/data; get -pR psI_sample2"
# EOF
