"""
Script that subsamples a dataset by randomly selecting a fraction of the data.
"""

import random

def sub_sample(src, trg, sub_src, sub_trg, samples=100000):

    with open(src, 'r', encoding='utf-8') as src_file, open(trg, 'r', encoding='utf-8') as trg_file:
        src_lines = src_file.readlines()
        trg_lines = trg_file.readlines()

    assert len(src_lines) == len(trg_lines)

    total_samples = len(src_lines)
    if samples > total_samples:
        samples = total_samples

    indices = random.sample(range(total_samples), samples)

    with open(sub_src, 'w', encoding='utf-8') as sub_src_file, open(sub_trg, 'w', encoding='utf-8') as sub_trg_file:
        for id in indices:
            sub_src_file.write(src_lines[id])
            sub_trg_file.write(trg_lines[id])


if __name__ == '__main__':
    random.seed(42)
    sub_sample('data/train.ro-en.en', 'data/train.ro-en.ro', 'data/sub_train.ro-en.en', 'data/sub_train.ro-en.ro')