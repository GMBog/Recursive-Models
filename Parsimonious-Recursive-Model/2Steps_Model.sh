#!/bin/bash
#SBATCH --job-name=blup12    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=gmboggio@gmail.com     # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --time=360:00:00               # Time limit hrs:min:sec
#SBATCH --output=blup1_2.log   # Standard output and error log
pwd; hostname; date

# uncomment to argument
while getopts h:k: option
 do
        case ${option}
        in
         h) param1=${OPTARG};;
         k) param2=${OPTARG};;
 esac
done


sed -i "14 s/\([^ ]\+\)/0/" $param1
sed -i "16 s/\([^ ]\+\)/0/" $param1

sed -i "14 s/\([^ ]\+\)/0/" $param2
sed -i "16 s/\([^ ]\+\)/0/" $param2

rm tmp
echo trait GV1 MV RV h2d SE_h2d m2 SE_m2 mean_uhat var_uhat GV RV h2m SE_h2m > results_param

for i in {5..7}
do

        if [[ ("$i" -eq "5") ]]
        then

         sed -i "6 s/\([^ ]\+\)/$i/" $param1
         sed -i "14 s/\([^ ]\+\)/0/" $param1
         sed -i "16 s/\([^ ]\+\)/0/" $param1
         sed -i "14 s/\([^ ]\+\)/0/" $param2
         sed -i "16 s/\([^ ]\+\)/0/" $param2


        else

         sed -i "6 s/\([^ ]\+\)/$i/" $param1
         sed -i "14 s/\([^ ]\+\)/3/" $param1
         sed -i "16 s/\([^ ]\+\)/4/" $param1
         sed -i "14 s/\([^ ]\+\)/3/" $param2
         sed -i "16 s/\([^ ]\+\)/4/" $param2


        fi


        echo "" >> renum1.out
        echo "trait= $i #######################" >> renum1.out

        renumf90 $param1 >> renum1.out

        sed -i '26 a RANDOM_GROUP' renf90.par
        sed -i '27 a 4' renf90.par
        sed -i '28 a RANDOM_TYPE' renf90.par
        sed -i '29 a user_file' renf90.par
        sed -i '30 a FILE' renf90.par
        sed -i '31 a Mi_98.txt' renf90.par
        sed -i '32 a (CO)VARIANCES' renf90.par
        sed -i '33 a 0.25' renf90.par

        echo "" >> blup1.out
                echo "trait= $i #######################" >> blup1.out

        blupf90+ renf90.par >> blup1.out

                tail -n48 blup1.out > tmp

        Logl=$(sed -n '1'p tmp | awk '{print $3}')
        conv=$(sed -n '2'p tmp | awk '{print $5}')

        GV1=$(sed -n '15'p tmp | awk '{print $1}')
        MV=$(sed -n '17'p tmp | awk '{print $1}')
        RV1=$(sed -n '19'p tmp | awk '{print $1}')
        seGV1=$(sed -n '29'p tmp | awk '{print $1}')
        seMV=$(sed -n '31'p tmp | awk '{print $1}')
        seRV1=$(sed -n '33'p tmp | awk '{print $1}')

        h2=$(sed -n '38'p tmp | awk '{print $2}')
        sh2=$(sed -n '39'p tmp | awk '{print $3}')
        ssdh2=$(sed -n '40'p tmp | awk '{print $3}')

        m2=$(sed -n '43'p tmp | awk '{print $2}')
        sm2=$(sed -n '44'p tmp | awk '{print $3}')
        ssdm2=$(sed -n '45'p tmp | awk '{print $3}')


        echo "BLUP1 trait= $i  ####################" >> blupsol
        cat tmp >> blupsol

        ## Solutions BLUP1

        mv solutions solutions1

        # Join solutions and data by IDs

        awk '{if ($1 >=1 && $1 <=434) print $1,$10}' renadd03.ped > ped_ids

        sort -k 1,1 ped_ids > tmp
        mv tmp ped_ids

        awk '{if ($2==4) print $3,$4}' solutions1 > sol_u_hat
        sort -k 1,1 sol_u_hat > tmp
        mv tmp sol_u_hat

        join -1 1 -2 1 sol_u_hat ped_ids > new_sol

                sort -k 3,3 new_sol > tmp
        mv tmp new_sol

        sort -k 1,1 data_RFI.dat > tmp
        mv tmp data_RFI.dat

        join -1 3 -2 1 new_sol data_RFI.dat > sol_BLUP1

        awk '{print $3,$4,$5,$6,$1}' sol_BLUP1 > tmp
        mv tmp data_u_hat.dat



        ## 2. BLUP2 with prior parameter estimation

        echo "" >> renum2.out
        echo "trait= $i #######################" >> renum2.out

        renumf90 $param2 >> renum2.out

        echo "" >> blup2.out
        echo "trait= $i #######################" >> blup2.out


        mean_uhat=$(awk 'BEGIN{r=0}; {r=r+$1}; END{print r/NR}' renf90.dat)
        var_uhat=$(awk 'BEGIN{r=0;sq=0}; {r+=$1 ; sq+=$1*$1}; END{print sq/NR-(total/NR)**2}' renf90.dat)

        blupf90+ renf90.par >> blup2.out

        tail -n25 blup2.out > tmp

        GV2=$(sed -n '3'p tmp | awk '{print $1}')
        RV2=$(sed -n '5'p tmp | awk '{print $1}')

        mh2c=$(sed -n '20'p tmp | awk '{print $2}')
        ssdh2c=$(sed -n '22'p tmp | awk '{print $3}')


        echo $i $GV1 $MV $RV1 $h2 $ssdh2 $m2 $ssdm2 $mean_uhat $var_uhat $GV2 $RV2 $mh2c $ssdh2c >> results_param

        echo "BLUP2 trait= $i  ####################" >> blupsol
        cat tmp >> blupsol

done


