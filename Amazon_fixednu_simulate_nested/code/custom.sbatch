#!/bin/sh

#SBATCH --output=slurmlogs/%x_%A_%a.out
#SBATCH --error=slurmlogs/%x_%A_%a.err
#SBATCH --nodes=1
#SBATCH --partition=broadwl 
#SBATCH --account=pi-jdingel
#SBATCH --array=1-50
#SBATCH --time=0-28:00:00
#SBATCH --mem-per-cpu=2g 
#SBATCH --job-name=gran_sim_choice_nested
#SBATCH --ntasks-per-node=1
#SBATCH --mail-type=FAIL
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
$command1
echo "I am going to run $command2 $SLURM_ARRAY_TASK_ID"
$command2 $SLURM_ARRAY_TASK_ID
