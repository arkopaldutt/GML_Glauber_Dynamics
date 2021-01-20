#!/bin/bash

# Slurm sbatch options
#SBATCH -o PL_ibmq_expt.log-%j
#SBATCH -N 1
#SBATCH -n 40

# Initialize the module command first
source /etc/profile

# Load Conda environment
conda activate active-learning-env

# Call your script as you would from the command line
python job_mp_PL_runner_expt.py


