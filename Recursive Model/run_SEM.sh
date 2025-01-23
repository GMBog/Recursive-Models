#!/bin/bash
#SBATCH --job-name=SEM              # Job name
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=@gmail.com  # Where to send mail
#SBATCH --nodes=1                   # Use one node
#SBATCH --ntasks=1                  # Run a single task
#SBATCH --mem-per-cpu=100mb           # Memory per processor
#SBATCH --time=90:00:00
#SBATCH --output=output.out    # Standard output and error log
#SBATCH --error=output.err

#Create the directory where results will be saved. 
##If you have 3 phenotypes (5, 6, and 7) then you need to create 3 dir
mkdir /SEM_blupf90/ASVS/5
mkdir /SEM_blupf90/ASVS/6
mkdir /SEM_blupf90/ASVS/7

#Loop to run parallel jobs (1 phenotype and 1 microbe at a time)
for i in {5..7} #Phenotypes
do

        for j in {8..100} #Microbiome
        do

                sbatch SEM.sh -p $i -m $j #Argument p is the phenotype and m is the microbiome
                sleep 1

        done

done
