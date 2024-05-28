#!/bin/bash

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

# file paths
train_ro=$data/sub_train.ro-en.ro
train_en=$data/sub_train.ro-en.en
dev_ro=$data/dev.ro-en.ro
dev_en=$data/dev.ro-en.en
test_ro=$data/test.ro-en.ro
test_en=$data/test.ro-en.en

# concatenated file for BPE training
cat $train_ro $train_en > $data/train.ro-en

# learn BPE with a vocab size 2000 or 5000
subword-nmt learn-joint-bpe-and-vocab --input $data/train.ro-en -s 2000 --total-symbols -o $data/bpe.codes --write-vocabulary $data/vocab.bpe

# BPE to training data
subword-nmt apply-bpe -c $data/bpe.codes < $train_ro > $data/train.bpe.ro
subword-nmt apply-bpe -c $data/bpe.codes < $train_en > $data/train.bpe.en

# BPE to development data
subword-nmt apply-bpe -c $data/bpe.codes < $dev_ro > $data/dev.bpe.ro
subword-nmt apply-bpe -c $data/bpe.codes < $dev_en > $data/dev.bpe.en

# BPE to test data
subword-nmt apply-bpe -c $data/bpe.codes < $test_ro > $data/test.bpe.ro
subword-nmt apply-bpe -c $data/bpe.codes < $test_en > $data/test.bpe.en
