#!/bin/bash

#SBATCH -J slp_infer # job name
#SBATCH -p gpu # partition
#SBATCH -N 1   # number of nodes
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -n 8 # number of cores
#SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH --gres gpu:1 # request 1 GPU
#SBATCH -o slurm.%x.%N.%j.out # write STDOUT
#SBATCH -e slurm.%x.%N.%j.err # write STDERR
#SBATCH --mail-type=ALL
#SBATCH --mail-user=user@domain.com
#SBATCH --array=0-1

# Load the SLEAP module
module load SLEAP

# Define directories for exported SLEAP job package and videos
SLP_JOB_NAME=labels.v001.slp.training_job
SLP_JOB_DIR=/ceph/scratch/$USER/$SLP_JOB_NAME
VIDEO_DIR=/ceph/scratch/neuroinformatics-dropoff/SLEAP_HPC_test_data/course-hpc-2023/videos

VIDEO1_PREFIX=sub-01_ses-01_task-EPM_time-165049
VIDEO2_PREFIX=sub-02_ses-01_task-EPM_time-185651
VIDEOS_PREFIXES=($VIDEO1_PREFIX $VIDEO2_PREFIX)
CURRENT_VIDEO_PREFIX=${VIDEOS_PREFIXES[$SLURM_ARRAY_TASK_ID]}
echo "Current video prefix: $CURRENT_VIDEO_PREFIX"

# Go to the job directory
cd $SLP_JOB_DIR

# Make a directory to store the predictions
mkdir -p predictions

# Run the inference command
sleap-track $VIDEO_DIR/${CURRENT_VIDEO_PREFIX}_video.mp4 \
    -m $SLP_JOB_DIR/models/231130_160757.centroid/training_config.json \
    -m $SLP_JOB_DIR/models/231130_160757.centered_instance/training_config.json \
    -o $SLP_JOB_DIR/predictions/${CURRENT_VIDEO_PREFIX}_array_predictions.slp \
    --gpu auto \
    --no-empty-frames
