# Inferring Causal Effects from Observational Data

Inferring causal effects from observational data is a challenging task due to potential confounding factors. To address these challenges, careful analysis using specific statistical techniques and assumptions is essential. 

A critical concept in causal inference is recognizing that knowledge of an association between two variables is insufficient to establish causality. This is often summarized as: **"Correlation does not imply causation."**

Structural equation models (SEM) are powerful tools that can postulate unidirectional causality, also known as a **Recursive Model (RM)**, where one variable (e.g., \( y_1 \)) influences another (e.g., \( y_2 \)), or vice versa. In the field of quantitative genetics and animal breeding, Gianola and Sorensen (2004) pioneered the application of SEM in the context of mixed models.

## Recursive Models

The statistical definition of a recursive model is expressed as:

```latex
\[
\Lambda y_i = X_ib + u_i + e_i 
```


We, Guillermo and Pedro, developed **bash** and **R codes** to implement SEMs while studying the microbiome and feed efficiency traits in dairy cattle and pigs. Our research, published in the *Journal of Dairy Science* ([DOI: 10.3168/jds.2024-24675](https://doi.org/10.3168/jds.2024-24675)) and forthcoming work on pigs, aims to quantify the **indirect effects of the genome** on phenotypes mediated by the gut microbiome.  
  

y₁ = Xβ + a + e  
y₂ = y₁ + Xβ + a + e 

Where:  
- **y₁**: Trait with a recursive effect on **y₂** (e.g., microbiome)
- **y₂**: Trait of interest (e.g., RFI, CH4) 
- **Xβ**: Fixed effects  
- **a**: Additive genetic effects  
- **e**: Residual effects  

## Implementation  

This repository provides the code to implement an RM in two scenarios:  

1. **Data available for all traits and animals**
     
3. **Data available for one trait across all animals and for the other(s) only in a subset**  

