#! /bin/bash

#SBATCH --job-name=evaluate
#SBATCH --time=4:00:00
#SBATCH --cpus-per-task=6
#SBATCH --mem=32GB
#SBATCH --output=evaluate-job.out
#SBATCH --error=evaluate-job.err

#SBATCH --ntasks=1
#SBATCH --gres gpu:1
#SBATCH --constraint=GPUMEM80GB

scripts=$(dirname "$0")
base=/scratch/$(whoami)/ex_05/mt-exercise-5/scripts/..

data=$base/data
configs=$base/configs

translations=$base/translations

mkdir -p $translations

src=ro
trg=en 

num_threads=6
device=0

# measure time

SECONDS=0

model_name=bpe-subword

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/$model_name

mkdir -p $translations_sub

# add loop here 

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test.ro-en.$src > $translations_sub/test.ro-en.$model_name.$trg

# compute case-sensitive BLEU 

cat $translations_sub/test.ro-en.$model_name.$trg | sacrebleu $data/test.ro-en.$trg


echo "time taken:"
echo "$SECONDS seconds"
