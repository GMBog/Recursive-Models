# Structural Equation Models (SEM) in Animal Breeding and Genetics  

Structural Equation Models (SEM), also known as Recursive Models (RM), are powerful tools in Animal Breeding and Genetics. Introduced to the field by **Prof. Daniel Gianola**, SEMs have been widely used to explore relationships between traits across various species.  

We, Guillermo and Pedro, developed **bash** and **R codes** to implement SEMs while studying the microbiome and feed efficiency traits in dairy cattle and pigs. Our research, published in the *Journal of Dairy Science* ([DOI: 10.3168/jds.2024-24675](https://doi.org/10.3168/jds.2024-24675)) and forthcoming work on pigs, aims to quantify the **indirect effects of the genome** on phenotypes mediated by the gut microbiome.  

## Model Description  

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

