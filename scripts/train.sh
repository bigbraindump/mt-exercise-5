#! /bin/bash

#SBATCH --job-name=train
#SBATCH --time=2:00:00
#SBATCH --cpus-per-task=6
#SBATCH --mem=32GB
#SBATCH --output=train-job.out
#SBATCH --error=train-job.err

#SBATCH --ntasks=1
#SBATCH --gres gpu:1
#SBATCH --constraint=GPUMEM80GB

scripts=$(dirname "$0")
base=/scratch/$(whoami)/ex_05/mt-exercise-5/scripts/..

models=$base/models
configs=$base/configs

mkdir -p $models

num_threads=6

# measure time

SECONDS=0

logs=$base/logs

model_name=bpe-subword

mkdir -p $logs

mkdir -p $logs/$model_name

OMP_NUM_THREADS=$num_threads python -m joeynmt train $configs/$model_name.yaml > $logs/$model_name/out 2> $logs/$model_name/err

echo "time taken:"
echo "$SECONDS seconds"
