#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=fs_<species>
#SBATCH --partition=quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH -V

# Run fastSTRUCTURE with a logistic prior to detect subtle population structure on both filtering regimes. Thinned datasets are
# needed due to the programs assumptions about linkage equilibrium. 

python <path to faststructure installation directory>/structure.py -K 3 --prior=logistic --input=<species>_10kbp2 --output=output/<species>_10

python <path to faststructure installation directory>/structure.py -K 3 --prior=logistic --input=<species>_20kbp2 --output=output/<species>_20




