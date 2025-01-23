#!/bin/bash

#This script was written by Guillermo Martinez Boggio and Pedro Nuñez.
#Run a Multi-trait mixed model (MTM) and it is reparametrization to obtain variance components under recursive model (RM).

while getopts m:p: option #m and p are previously defined in run_SEM.sh 
    case "${option}" in
        m) col=${OPTARG};;
      	p) phenotype=${OPTARG};;
            esac
done

#Transforming column number of each microbiome in the corresponding number of row it will have in results
microbiome=$((col - 17)) #The first microbe is in the column 18


#Setting Input and Output files

INPUTDIR=/usu/pnuez/Ingafood/SEM/ASV
OUTPUTDIR=/usu/pnuez/Ingafood/SEM/ASV/results

#Create a directory for each microbe (y1) and phenotype (y2) 

mkdir $OUTPUTDIR/${phenotype}/${microbiome}

#Set the directory

cd $OUTPUTDIR/${phenotype}/${microbiome}

##Creating the new data with ID, fixed effects, y1 and y2

cp $INPUTDIR/datafile.txt data.dat

#Use awk to reorder columns in data.dat

awk -v p="$phenotype" -v c="$col" '{print $1, $16, $12, $p, $c}' data.dat > tmp

#1=ID, 16 = covariate initial age, 12=pen

mv tmp data.dat

cp $INPUTDIR/pedigree.txt pedigree.txt

echo $INPUTDIR/param.txt|$INPUTDIR/renumf90 

$INPUTDIR/gibbsf90+ renf90.par --samples 1000000 --burnin 200000 --interval 100
printf "renf90.par\n200000\n100\n100\n0" | $INPUTDIR/postgibbsf90 > err.log



# Now we have all the variance components under a standard mixed model

Rscript MTMtoRM.R



rm -f tmp
awk -v p="$phenotype" -v c="$microbiome" '{print p, c, $0}' results_gibbs.txt > tmp

mv tmp results_gibbs.txt
cp results_gibbs.txt $OUTPUTDIR/gibbs_${phenotype}_${microbiome}

rm all_solutions
rm gibbs_samples
rm fort.99
rm last_solutions
rm binary_final_solutions
rm pedigree_2.txt
rm data.dat
rm renadd04.ped
rm renf90.tables
rm renf90.fields
rm postsd
rm postmeanCorr
rm postind
rm fort.456
rm fort.998
rm renf90.dat

#Extract convergence indicators. The number of row might depend on the number of traits and effects

varA_t1_ESS=$(sed -n '56'p err.log | awk '{print $10}')
varA_t1_ICS=$(sed -n '56'p err.log | awk '{print $13}')
varA_t1_gew=$(sed -n '69'p err.log | awk '{print $10}')
varA_t1_lag10=$(sed -n '69'p err.log | awk '{print $12}')
varA_t1_lag50=$(sed -n '69'p err.log | awk '{print $13}')
varA_t1_IB=$(sed -n '69'p err.log | awk '{print $14}')

covA_ESS=$(sed -n '57'p err.log | awk '{print $10}')
covA_ICS=$(sed -n '57'p err.log | awk '{print $13}')
covA_gew=$(sed -n '70'p err.log | awk '{print $10}')
covA_lag10=$(sed -n '70'p err.log | awk '{print $12}')
covA_lag50=$(sed -n '70'p err.log | awk '{print $13}')
covA_IB=$(sed -n '70'p err.log | awk '{print $14}')

varA_t2_ESS=$(sed -n '58'p err.log | awk '{print $10}')
varA_t2_ICS=$(sed -n '58'p err.log | awk '{print $13}')
varA_t2_gew=$(sed -n '71'p err.log | awk '{print $10}')
varA_t2_lag10=$(sed -n '71'p err.log | awk '{print $12}')
varA_t2_lag50=$(sed -n '71'p err.log | awk '{print $13}')
varA_t2_IB=$(sed -n '71'p err.log | awk '{print $14}')

varE_t1_ESS=$(sed -n '59'p err.log | awk '{print $10}')
varE_t1_ICS=$(sed -n '59'p err.log | awk '{print $13}')
varE_t1_gew=$(sed -n '72'p err.log | awk '{print $10}')
varE_t1_lag10=$(sed -n '72'p err.log | awk '{print $12}')
varE_t1_lag50=$(sed -n '72'p err.log | awk '{print $13}')
varE_t1_IB=$(sed -n '72'p err.log | awk '{print $14}')

covE_ESS=$(sed -n '60'p err.log | awk '{print $10}')
covE_ICS=$(sed -n '60'p err.log | awk '{print $13}')
covE_gew=$(sed -n '73'p err.log | awk '{print $10}')
covE_lag10=$(sed -n '73'p err.log | awk '{print $12}')
covE_lag50=$(sed -n '73'p err.log | awk '{print $13}')
covE_IB=$(sed -n '73'p err.log | awk '{print $14}')

varE_t2_ESS=$(sed -n '61'p err.log | awk '{print $10}')
varE_t2_ICS=$(sed -n '61'p err.log | awk '{print $13}')
varE_t2_gew=$(sed -n '74'p err.log | awk '{print $10}')
varE_t2_lag10=$(sed -n '74'p err.log | awk '{print $12}')
varE_t2_lag50=$(sed -n '74'p err.log | awk '{print $13}')
varE_t2_IB=$(sed -n '74'p err.log | awk '{print $14}')

lambda_ESS=$(sed -n '62'p err.log | awk '{print $7}')
lambda_ICS=$(sed -n '62'p err.log | awk '{print $10}')
lambda_gew=$(sed -n '75'p err.log | awk '{print $7}')
lambda_lag10=$(sed -n '75'p err.log | awk '{print $9}')
lambda_lag50=$(sed -n '75'p err.log | awk '{print $10}')
lambda_IB=$(sed -n '75'p err.log | awk '{print $11}')

echo $phenotype $microbiome $varA_t1_ESS $varA_t1_ICS $varA_t1_gew $varA_t1_lag10 $varA_t1_lag50 $varA_t1_IB $covA_ESS $covA_ICS $covA_gew $covA_lag10 $covA_lag50 $covA_IB $varA_t2_ESS $varA_t2_ICS $varA_t2_gew $varA_t2_lag10 $varA_t2_lag50 $varA_t2_IB $varE_t1_ESS $varE_t1_ICS $varE_t1_gew $varE_t1_lag10 $varE_t1_lag50 $varE_t1_IB $covE_ESS $covE_ICS $covE_gew $covE_lag10 $covE_lag50 $covE_IB $varE_t2_ESS $varE_t2_ICS $varE_t2_gew $varE_t2_lag10 $varE_t2_lag50 $varE_t2_IB $lambda_ESS $lambda_ICS $lambda_gew $lambda_lag10 $lambda_lag50 $lambda_IB > convergence.txt

mv convergence.txt $OUTPUTDIR/conv_${phenotype}_${microbiome}
