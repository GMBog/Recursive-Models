# Inferring Causal Effects from Observational Data

Inferring causal effects from observational data is a challenging task due to potential confounding factors. To address these challenges, careful analysis using specific statistical techniques and assumptions is essential. 

A critical concept in causal inference is recognizing that knowledge of an association between two variables is insufficient to establish causality. This is often summarized as: **"Correlation does not imply causation."**

Structural equation models (SEM) are powerful tools that can postulate unidirectional causality, also known as a **Recursive Model (RM)**, where one variable (e.g., \( y_1 \)) influences another (e.g., \( y_2 \)), or vice versa. In the field of quantitative genetics and animal breeding, Gianola and Sorensen (2004) pioneered the application of SEM in the context of mixed models.

## Recursive Models

The statistical definition of a recursive model is expressed as:

Λy = Xb + a + e

where b is the vector of fixed effects, y, u, and e are m × 1 vectors of phenotypic measurements, additive genetic effects and residuals of the m traits associated with the ith multivariate record, and X is its corresponding incidence matrix. Λ is an m × m matrix of the recursive parameters with ones on the diagonal and minus the recursive effects of the ith trait on the jth trait (−λ1→j) in some or all the elements below the diagonal.

This RM can be reparametrized as a standard mixed model (MTM) by multiplying all terms of [1] by Λ−1, as follows:

y =  Λ^(-1)Xb + Λ^(-1)u + Λ^(-1)e =  Λ^(-1)Xb + u* + e*

To achieve the inference of the parameters involved, some restrictions must be imposed. In animal breeding models, 2 strategies have been used to achieve statistical identification:
  **(1) imposing restrictions on the elements of the (co)variance component matrices (Varona et al., 2007)**
  (2) imposing constraints in the form of linear combinations of explanatory variables to dispose of instrumental variables (Gianola and Sorensen, 2004)

In RM, the recursive parameter λ1→2 is the expected change in trait y₂ for each unit of change in trait y₁, which affects other important parameters such as heritability and genetic correlation.

y₁ = X₁β₁ + a₁ + e₁  
y₂ = y₁ + X₂β₂ + a₂ + e₂ 

where, y₁ is the trait with a recursive effect on y₂ (e.g., microbiome), y₂ is the trait of interest (e.g., RFI, CH4), Xβ are the fixed effects for each trait, a is the additive genetic effects, e is the residual effect.  


## Implementation

We, Guillermo and Pedro, developed **bash** and **R codes** to implement SEM while studying the microbiome and feed efficiency traits in dairy cattle and pigs. Our research, published in the *Journal of Dairy Science* ([DOI: 10.3168/jds.2024-24675](https://doi.org/10.3168/jds.2024-24675)) and forthcoming work on pigs, aims to quantify the **indirect effects of the genome** on phenotypes mediated by the gut microbiome.  
  
This repository provides the code to implement an RM in two scenarios:  

1. **Data available for all traits and animals**

In that case, the user can fit a recursive model fixing the residual co-variances to 0, and including the trait with recursive effect as a covariable for the other trait in the model.
For that scenario, codes are available at /Recursive Model
     
2. **Data available for one trait across all animals and for the other(s) only in a subset**  

If the user does not have animals with data for the two traits, so then it is necessary to fit a MTM and then reparametrized to RM using the methods proposed by Varona et al. (2024).
For this second scenario, codes are available at /Multi-Trait Model to Recursive Model


