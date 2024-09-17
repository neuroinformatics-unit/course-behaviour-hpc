#!/bin/bash

#SBATCH -p fast # partition (queue)
#SBATCH -N 1   # number of nodes
#SBATCH --mem 1G # memory pool for all cores
#SBATCH -n 1 # number of cores
#SBATCH -t 0-0:1 # time (D-HH:MM)
#SBATCH -o slurm_array_%A-%a.out
#SBATCH -e slurm_array_%A-%a.err
#SBATCH --array=0-9%4

# Array job runs 10 separate jobs, but not more than four at a time.
# This is flexible and the array ID ($SLURM_ARRAY_TASK_ID) can be used in any way.

echo "Multiplying $SLURM_ARRAY_TASK_ID by 10"
./multiply.sh $SLURM_ARRAY_TASK_ID 10 

