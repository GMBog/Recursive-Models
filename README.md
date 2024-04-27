Structural Equation Models (SEM)

Bash scripts to run Structural Equation models or Recursive models using BLUPF90 software.

This script will run SEM for the most simple model, 2 traits, with one of them having a phenotypic recursive effect on the other one.
We will run a bi-trait model where y1 (dependent trait) enters as covariable in the model for y2 (independent trait).

y2 = y1 + Xb + a + e







To compile results in a single file when all your jobs are done:
cat /SEM_blupf90/ASVS/results_SEM* > table_ALLresults_SEM.txt
cat /SEM_blupf90/ASVS/solEBV* > solutions_EBV_SEM.txt


For more details on the analysis and results using this script you can read Martinez Boggio et al. (2024) DOI:
