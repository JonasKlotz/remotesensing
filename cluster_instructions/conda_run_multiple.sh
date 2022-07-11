#!/bin/bash

#SBATCH -J ASL_TRAINING	# Job Name

#SBATCH --nodes=1               # Anzahl Knoten N
#SBATCH --ntasks-per-node=5     # Prozesse n pro Knoten
#SBATCH --ntasks-per-core=5	  # Prozesse n pro CPU-Core
#SBATCH --mem=10G              # 500MiB resident memory pro node

##Max Walltime vorgeben:
#SBATCH --time=24:00:00 # Erwartete Laufzeit

## AUf GPU Rechnen
#SBATCH --partition=gpu
#SBATCH --gres=gpu:tesla:1                      # Use 1 GPU per node



#SBATCH -o logs/logfile_conda_all                  # send stdout to outfile
#SBATCH -e logs/errfile_conda_all                  # send stderr to errfile


conda activate rs_3.8


echo Start

# Parameters for running
model=("resnet_base" "clbc" "lamp")
loss=("weighted_bce" "bce", "asl")
optim=("adam"  "sgd")
d_model=(50 300)
learning_rates=(0.001  0.005)
batchsize=(32 64 128)

set len=3*3*2*2*2*3
set counter=0
set counter+=1


for m in ${model[@]}; do
	for l in ${loss[@]}; do
		for o in ${optim[@]}; do
			for d in ${d_model[@]}; do
				for lr in ${learning_rates[@]}; do
					for bs in ${batchsize[@]}; do
						args="-model ${m} -loss ${l} -optim ${o} -d_model ${d} -lr ${lr}"
						python3 src/main.py $args
						echo "$counter of $len done" > out.txt
					done
				done
			done
		done
	done
done

