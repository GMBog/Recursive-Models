#!/bin/bash
#SBATCH --job-name=SEM              # Job name
#SBATCH --mail-type=END,FAIL            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=gmboggio@gmail.com  # Where to send mail
#SBATCH --nodes=1                   # Use one node
#SBATCH --ntasks=1                  # Run a single task
#SBATCH --mem-per-cpu=100mb           # Memory per processor
#SBATCH --time=90:00:00
#SBATCH --output=output.out    # Standard output and error log
#SBATCH --error=output.err

#mkdir /blue/mateescu/martinezbogg.wisc/model_omics/model_SEM/SEM_blupf90/ASVS/5
#mkdir /blue/mateescu/martinezbogg.wisc/model_omics/model_SEM/SEM_blupf90/ASVS/6
#mkdir /blue/mateescu/martinezbogg.wisc/model_omics/model_SEM/SEM_blupf90/ASVS/7


for i in {5..7}
do

        for j in {8..10}
        do

                sbatch SEM.sh -p $i -m $j
                sleep 1

        done

done


#cat /blue/mateescu/martinezbogg.wisc/model_omics/model_SEM/SEM_blupf90/ASVS/results_SEM* > table_ALLresults_SEM.txt
#cat /blue/mateescu/martinezbogg.wisc/model_omics/model_SEM/SEM_blupf90/ASVS/solEBV* > solutions_EBV_SEM.txt
#cat /blue/mateescu/martinezbogg.wisc/model_omics/model_SEM/SEM_blupf90/ASVS/pev* > pev_SEM.txt
