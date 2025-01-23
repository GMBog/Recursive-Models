#!/bin/bash

# Create folders where the analysis for each trait will be run and save
mkdir /dir/SEM/ASV/results/6/
mkdir /dir/SEM/ASV/results/17/

# List of traits
TRAIT=(6 17) #t1 t2 positions

# Nested loop to run analysis for each combination of trait and microbiome
for i in "${TRAIT[@]}"
 do

   for j in {18..626} #Iterate over all microbial traits 
    do

        sbatch repar_SEM.sh -p $i -m $j
        sleep 1

    done

 done
