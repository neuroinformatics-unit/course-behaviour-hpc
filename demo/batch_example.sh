#!/bin/bash

#SBATCH -p fast # partition (queue)
#SBATCH -N 1   # number of nodes
#SBATCH --mem 1G # memory pool for all cores
#SBATCH -n 1 # number of cores
#SBATCH -t 0-0:1 # time (D-HH:MM)
#SBATCH -o slurm_output.out
#SBATCH -e slurm_error.err

for i in {1..5}
do
  ./multiply.sh $i 10
done
