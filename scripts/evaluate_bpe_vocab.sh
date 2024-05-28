#! /bin/bash

#SBATCH --job-name=evaluate
#SBATCH --time=2:00:00
#SBATCH --cpus-per-task=6
#SBATCH --mem=32GB
#SBATCH --output=evaluate-job.out
#SBATCH --error=evaluate-job.err

#SBATCH --ntasks=1
#SBATCH --gres gpu:1
#SBATCH --constraint=GPUMEM80GB

if [ -z "$1" ]; then
    echo "Model name (directory) not provided"
    exit 1
fi

model_name=$1  # Accept model name (directory) as a parameter

scripts=$(dirname "$0")
base=/scratch/$(whoami)/ex_05/mt-exercise-5

data=$base/data
configs=$base/configs
translations=$base/translations

mkdir -p $translations

src=ro
trg=en

num_threads=6
device=0

translations_sub=$translations/$model_name
mkdir -p $translations_sub

# Loop through different beam sizes and collect BLEU scores and times
for beam_size in {1..10}
do
    SECONDS=0  # Reset timer

    output_file=$translations_sub/test.beam_$beam_size.$trg

    # Create a temporary configuration file for this beam size
    temp_config=$configs/temp_config_$beam_size.yaml
    cp $configs/$model_name.yaml $temp_config
    echo "testing:
    beam_size: $beam_size
    alpha: 1.0" >> $temp_config

    echo "Translating with beam size: $beam_size"
    CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $temp_config < $data/test.bpe.$src > $output_file

    # Compute BLEU score
    bleu=$(sacrebleu $data/test.bpe.$trg < $output_file | grep 'score' | awk -F ':' '{print $2}' | awk -F ',' '{print $1}' | xargs)
    echo "Beam size: $beam_size, BLEU score: $bleu" >> $translations_sub/bleu_scores.txt

    # Log the time taken
    time_taken=$SECONDS
    echo "Beam size: $beam_size, Time taken: $time_taken seconds" >> $translations_sub/time_taken.txt

    # Remove the temporary configuration file
    rm $temp_config
done