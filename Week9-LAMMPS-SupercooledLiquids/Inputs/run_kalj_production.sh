#!/bin/bash



#SBATCH --job-name=KALJ_production

#SBATCH --output=kalj_production_%j.out

#SBATCH --error=kalj_production_%j.err

#SBATCH --nodes=1

#SBATCH --ntasks-per-node=4  # Suggested 4 tasks-per-node

#SBATCH --cpus-per-task=1

#SBATCH --partition=cs

#SBATCH --time=00:40:00  # Adjusted to be 3 times shorter than equilibration runs



# Load the necessary LAMMPS environment

source /scratch/work/courses/CHEM-GA-2671-2024fa/software/lammps-gcc-30Oct2022/setup_lammps.bash



# Navigate to Data directory

mkdir -p ../Data

cd ../Data



# Verify and copy necessary input files from the Inputs directory

if [[ -f ../Inputs/kalj.lmp ]]; then

    echo "kalj.lmp found, copying..."

    cp ../Inputs/kalj.lmp .

else

    echo "Error: kalj.lmp not found in Inputs. Exiting."

    exit 1

fi



if [[ -f ../Inputs/kalj_particles.lmp ]]; then

    echo "kalj_particles.lmp found, copying..."

    cp ../Inputs/kalj_particles.lmp .

else

    echo "Error: kalj_particles.lmp not found in Inputs. Exiting."

    exit 1

fi



# Production runs at progressively lower temperatures

# Define temperature files in an array

temperatures=(1.5 1.0 0.9 0.8 0.7 0.65 0.6 0.55 0.5 0.475)



# Loop through each temperature and run the production command

for temp in "${temperatures[@]}"; do

    config_file="../Inputs/n360/kalj_n360_T${temp}.lmp"

    if [[ -f "$config_file" ]]; then

        echo "Running production at temperature $temp..."

        mpirun lmp -var configfile $config_file -var id 1 -in ../Inputs/production_3d_binary.lmp

    else

        echo "Configuration file $config_file not found, skipping..."

    fi

done



echo "Production process completed."

