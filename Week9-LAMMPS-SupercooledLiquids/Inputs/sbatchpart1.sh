#!/bin/bash



#SBATCH --job-name=KALJ_cooling

#SBATCH --output=kalj_cooling_%j.out

#SBATCH --error=kalj_cooling_%j.err

#SBATCH --nodes=1

#SBATCH --ntasks-per-node=4  # Use 4 tasks-per-node as suggested

#SBATCH --cpus-per-task=1

#SBATCH --partition=cs

#SBATCH --time=01:00:00  # Adjusted to the expected 1-hour completion



# Load the necessary LAMMPS environment

source /scratch/work/courses/CHEM-GA-2671-2024fa/software/lammps-gcc-30Oct2022/setup_lammps.bash



# Create and navigate to Data directory

mkdir -p Data

cd Data



# Copy or link the necessary input files

ln -s ../Inputs/kalj.lmp .

ln -s ../Inputs/kalj_particles.lmp .



# Step 1: Create the system

mpirun lmp -var configfile ../Inputs/n360/kalj_n360_create.lmp -var id 1 -in ../Inputs/create_3d_binary.lmp



# Step 2: Equilibration at progressively lower temperatures

# Define temperature files in an array

temperatures=(1.5 1.0 0.9 0.8 0.7 0.65 0.6 0.55 0.5 0.475)



# Loop through each temperature and run the equilibration command

for temp in "${temperatures[@]}"; do

    config_file="../Inputs/n360/kalj_n360_T${temp}.lmp"

    if [[ -f "$config_file" ]]; then

        echo "Running equilibration at temperature $temp..."

        mpirun lmp -var configfile $config_file -var id 1 -in ../Inputs/anneal_3d_binary.lmp

    else

        echo "Configuration file $config_file not found, skipping..."

    fi

done



echo "Annealing process completed."

