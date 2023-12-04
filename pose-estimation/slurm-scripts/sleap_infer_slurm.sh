#!/bin/bash

#SBATCH -J slp_infer # job name
#SBATCH -p gpu # partition
#SBATCH -N 1   # number of nodes
#SBATCH --mem 64G # memory pool for all cores
#SBATCH -n 32 # number of cores
#SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH --gres gpu:rtx5000:1 # request 1 RTX5000 GPU
#SBATCH -o slurm.%x.%N.%j.out # write STDOUT
#SBATCH -e slurm.%x.%N.%j.err # write STDERR
#SBATCH --mail-type=ALL
#SBATCH --mail-user=user@domain.com

# Load the SLEAP module
module load SLEAP

# Define directories for exported SLEAP job package and videos
SLP_JOB_NAME=labels.v001.slp.training_job
SLP_JOB_DIR=/ceph/scratch/$USER/$SLP_JOB_NAME
VIDEO_DIR=/ceph/scratch/neuroinformatics-dropoff/SLEAP_HPC_test_data/course-hpc-2023/videos
VIDEO1_PREFIX=sub-01_ses-01_task-EPM_time-165049

# Go to the job directory
cd $SLP_JOB_DIR

# Make a directory to store the predictions
mkdir -p predictions

# Run the inference command
sleap-track $VIDEO_DIR/${VIDEO1_PREFIX}_video.mp4 \
    -m $SLP_JOB_DIR/models/231130_160757.centroid/training_config.json \
    -m $SLP_JOB_DIR/models/231130_160757.centered_instance/training_config.json \
    -o predictions/${VIDEO1_PREFIX}_predictions.slp \
    --gpu auto \
    --no-empty-frames
