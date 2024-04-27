#!/bin/bash

#Bash script to run a series of RECusrive models in blupf90
#Written by Guillermo Martinez Boggio

#Recursive multi-Trait models
#Two models where y1 (dependent trait) enters as covariable in the model for y2 (independent trait)

## y1 = Xb + a + e
## y2 = y1 + Xb + a + e


while getopts m:p: option
do
    case "${option}" in
        m) col=${OPTARG};;
	p) phenotype=${OPTARG};;
            esac
done

#Transform col number of each microbiome in the corresponding number of row it will have in results
microbiome=$((col - 7))

#Setting Input and Output files
INPUTDIR=/dirfiles
OUTPUTDIR=/SEM_blupf90/ASVS

#Create a directory for each phenotype (y2) and microbiome (y1)
mkdir $OUTPUTDIR/${phenotype}/${microbiome}

#Set the directory, and create the data and copy the genotypes 
cd $OUTPUTDIR/${phenotype}/${microbiome}

##Creating the new data with ID, fixed effects, y1 and y2
cp $INPUTDIR/data_ASV data.dat
cut -f 1,2,3,4,$col,$phenotype -d " " data.dat > tmp
mv tmp data.dat

##Copying the genome data (it will be remove at the end of the loop)
cp $INPUTDIR/G_matrix G.mat

#If you traits with different fixed effects then you will need different paramfile.par
#Choosing the parameter file to use for each model:
###Trait 5 does not have all fixed effects, only the microbiome (y1) effect
###Trait 6 and 7 have all effects

if [ $phenotype -eq 5 ]; then 
	renumf90 /SEM_blupf90/paramSEM5.par > renum.out

else
	renumf90 /SEM_blupf90/paramSEM67.par > renum.out

fi


#Run blupf90 with the parameter file for each model with y1 and y2
blupf90+ renf90.par > blup.out

#Extract the last part of the variance component estimation file
tail -n68 blup.out > tmp

Logl=$(sed -n '1'p tmp | awk '{print $3}')
conv=$(sed -n '2'p tmp | awk '{print $5}')

G1V=$(sed -n '15'p tmp | awk '{print $1}')
G2V=$(sed -n '16'p tmp | awk '{print $2}')
G12V=$(sed -n '16'p tmp | awk '{print $1}')
       
R1V=$(sed -n '26'p tmp | awk '{print $1}')
R2V=$(sed -n '27'p tmp | awk '{print $2}')
R12V=$(sed -n '27'p tmp | awk '{print $1}')

seG1V=$(sed -n '49'p tmp | awk '{print $1}')
seG2V=$(sed -n '50'p tmp | awk '{print $2}')
seG12V=$(sed -n '50'p tmp | awk '{print $1}')

seR1V=$(sed -n '52'p tmp | awk '{print $1}')
seR2V=$(sed -n '53'p tmp | awk '{print $2}')
seR12V=$(sed -n '53'p tmp | awk '{print $1}')

h2M=$(sed -n '58'p tmp | awk '{print $2}')
seh2M=$(sed -n '60'p tmp | awk '{print $3}')

h2P=$(sed -n '63'p tmp | awk '{print $2}')
seh2P=$(sed -n '65'p tmp | awk '{print $3}')

lambda=$(sed -n '3'p solutions | awk '{print $4}')
se_lambda=$(sed -n '3'p solutions | awk '{print $5}')

#Creating a new file with the variance components
echo $phenotype $microbiome $Logl $conv $lambda $se_lambda $G1V $seG1V $G2V $seG2V $G12V $seG12V $R1V $seR1V $R2V $seR2V $R12V $seR12V $h2M $seh2M $h2P $seh2P > results_SEM
mv results_SEM /SEM_blupf90/ASVS/results_SEM${phenotype}.${microbiome}

#Creating a file with the breeding values
awk '$2 == 4 {print '${phenotype}', '${microbiome}', $0}' solutions > /SEM_blupf90/ASVS/solEBV${phenotype}.${microbiome}

#Creating a file with prediction error variances
awk '{print '${phenotype}', '${microbiome}', $0}' pev_pec_bf90 > /SEM_blupf90/ASVS/pev${phenotype}.${microbiome}

#Remove files that are heavy like genome, and false pedigree
rm G.mat*
rm renadd*
rm freq*


