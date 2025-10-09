#!/bin/sh

#SBATCH --output=slurmlogs/%j.out
#SBATCH --error=slurmlogs/%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=5g
#SBATCH --mail-type=FAIL
#SBATCH --partition=broadwl
#SBATCH --account=pi-tintelnot

$command1
$command2
