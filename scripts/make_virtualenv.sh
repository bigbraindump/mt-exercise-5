#! /bin/bash

# virtualenv must be installed on your system, install with e.g.
# pip install virtualenv

module load python/3.10

# Download get-pip.py
curl -O https://bootstrap.pypa.io/get-pip.py

# Install pip for Python 3.10
python3.10 get-pip.py

# Upgrade pip
python3.10 -m pip install --upgrade pip

# Install virtualenv
python3.10 -m pip install virtualenv

scripts=$(dirname "$0")
base=/scratch/$(whoami)/ex_05/mt-exercise-5

mkdir -p $base/venvs

# Create a virtual environment using python3.10
python3.10 -m virtualenv $base/venvs/torch3

echo "To activate your environment:"
echo "    source $base/venvs/torch3/bin/activate"
