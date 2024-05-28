# MT Exercise 5: Byte Pair Encoding, Beam Search
This repository is a starting point for the 5th and final exercise. As before, fork this repo to your own account and the clone it into your prefered directory.

Members: Sarah Tariq (stariq), Khadidja Manaa (kmanaa)

## Requirements

- This only works on a Unix-like system, with bash available.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure virtualenv is installed on your system. To install, e.g.

    `pip install virtualenv`

## Steps

Clone your fork of this repository in the desired place:

    git clone https://github.com/bigbraindump/mt-exercise-5

Create a new virtualenv that uses Python 3.10. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software as described in the exercise pdf.

Download data:

    ./download_iwslt_2017_data.sh
    
Before executing any further steps, you need to make the modifications described in the exercise pdf.

Train a model:

    ./scripts/train.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Evaluate a trained model with

    ./scripts/evaluate.sh
    

## Task 1 - BPE comparisons

The language pair ro-en is used for this implementation.

Train 3 different systems to experiment with NMT model vocabulary. Configurations:

    a. Word-level with a vocab size of 2000
    b. BPE with a vocab size of 2000
    c. BPE with a vocab size of 5000
    
Limit the size of the training data to 100k sentence pairs using the ./scripts/sub_sample.py script.

Create 3 different configuration ./configs/*.yaml files for each of the model systems.

Train and evaluate model configuration a.

Following the guidelines from the following repo, create and run the ./scripts/bpe_subword.sh script for BPE preprocessing:
    
    https://github.com/rsennrich/subword-nmt/tree/master
    
Clean up the vocab.bpe files to remove the frequency occurences of tokens using the following command:

    cut -d ' ' -f 1 data/vocab.bpe > data/vocab_clean.bpe

Train and evaluate models b. and c. 

Results Table:

| Use BPE | Vocabulary Size | BLEU |
|---------|-----------------|------|
| (a) no  | 2000            | 8.0 |
| (b) yes | 2000            | 16.4 |
| (c) yes | 5000            | 19.6 |

Differences in translations from manual searches:

    The BLEU score for model configuration a. was quite low. On manual inspection, it's easy to determine the reason - many <unk> tokens in the tranlated text. 
    The training times for model configs b. and c. were also longer than a, more than two times the time taken, specifically for model config b.
    The evaluation for model config b. failed with a 0 BLEU score. This score may be due to errors in pre processing of the script. However, we hypothesize and would expect that the best performance
    would be from model config c.
    

## Task 2 - BEAM Search

Translate the test set 10 times with varying beam sizes using the edited ./scripts/evaluate.sh script. Use the best performing model from Task 1 (model config c., ./models/bpe-vocab) for comparisons.

    .scripts/evaluate_bpe_vocab.sh bpe-vocab

Visualize plots for beam size against BLEU scores and time taken for translations using ./scripts/beam_graph.py.

    python ./scripts/beam_graph.py bpe-vocab

A line graph was chosen for visualization since both the scores and time taken are continuous variables.

## Notes

Please note that both Tasks 1 and 2 were completed using the UZH Cluster resources. GPU instances were added to all the slurm scripts to speed up processing times.

## AI use

Copilot was used for debugging, specifically while creating a slurm script from the subword-nmt repo. 
