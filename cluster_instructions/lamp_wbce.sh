#!/bin/bash

#SBATCH -J lamp_wbce	# Job Name

#SBATCH --nodes=1               # Anzahl Knoten N
#SBATCH --ntasks-per-node=5     # Prozesse n pro Knoten
#SBATCH --ntasks-per-core=5	  # Prozesse n pro CPU-Core
#SBATCH --mem=15G              # 500MiB resident memory pro node

##Max Walltime vorgeben:
#SBATCH --time=60:00:00 # Erwartete Laufzeit

## AUf GPU Rechnen
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla:1                      # Use 1 GPU per node



#SBATCH -o logs/logfile_lamp_wbce                # send stdout to outfile
#SBATCH -e logs/errfile_lamp_wbce                  # send stderr to errfile

source ~/miniconda3/etc/profile.d/conda.sh
conda activate rs_3.8


echo Start

# Parameters for running
model=("lamp")
loss=("weighted_bce")
optim=("sgd")
d_model=(50)
learning_rates=(0.001)
noises=(0.1 0.3 0.5 0.7)


for m in ${model[@]}; do
	for l in ${loss[@]}; do
		for o in ${optim[@]}; do
			for d in ${d_model[@]}; do
				for lr in ${learning_rates[@]}; do
				  no_noise="-model ${m} -loss ${l} -optim ${o} -d_model ${d} -lr ${lr}"
          python3 src/main.py $no_noise
						for n in ${noises[@]}; do
              add_noise="-model ${m} -loss ${l} -optim ${o} -d_model ${d} -lr ${lr} -add_noise ${n}"
              python3 src/main.py $add_noise
              sub_noise="-model ${m} -loss ${l} -optim ${o} -d_model ${d} -lr ${lr} -sub_noise ${n}"
              python3 src/main.py $sub_noise
              balanced="-model ${m} -loss ${l} -optim ${o} -d_model ${d} -lr ${lr} -add_noise ${n} -sub_noise ${n}"
              python3 src/main.py $balanced
          done
				done
			done
		done
	done
done


