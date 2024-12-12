#!/bin/bash
#SBATCH --job-name=proton_aimd_1ns_every0.5fs  # Job name
#SBATCH --output=proton_aimd_1ns_every0.5fs.log  # Output log file
#SBATCH --tasks-per-node=12  # Total number of tasks (1 CPU per task)
#SBATCH --nodes=1    # Requesting 2 nodes (if 12 tasks need more nodes)
#SBATCH --mem=16GB   # Adjust memory as needed
#SBATCH --time=06:00:00  # Wall time (6 hours)

# Load the cp2k module
module load cp2k/openmpi/intel/20201212

# Run the CP2K simulation using mpirun
mpirun -np 12 cp2k.popt -i proton.inp -o OUTPUT_FILE_NAME.log

