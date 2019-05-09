# Subgroup Analysis with the Ovary dataset
## Xiaoqing Ye

## Data
### Abstract
The data set consists of mRNA-seq of 17814 gene expressions from 561 ovary patients. After omitting the NA datathe dataset remains 17812 gene expressions. Only 703 gene expressions are used for the analysis. The fitted value which obtained by projecting expression level of BRCA1 into the top two relevant gene-expression-levels(i.e., NBR2 and TOP2A) is used as the response variable. And then 700 gene expressions are regarded as explanatory variable ranging from 330th to 1030th. Thus, the data used is with $p\gg n$

### Availability
This Ovary data set is available is publicly available on the database called TCGA(The Cancer Genome Atlas) via the website [https://portal.gdc.cancer.gov/](url), or it also can be downloaded with TCGA R-package.
```{R, eval=F}
source("http://bioconductor.org/biocLite.R")
biocLite("RTCGA")
biocLite("RTCGA.mRNA")
#biocLite("RTCGA.clinical")
#biocLite("RTCGA.rnaseq")
#biocLite("RTCGA.mutations")

library(RTCGA)
library(RTCGA.mRNA)
#library(RTCGA.clinical)
#library(RTCGA.rnaseq)
#library(RTCGA.mutations)

expr = expressionsTCGA(OV.mRNA) 
```


### Description
The data is published on database just as the above said, no register is avaliable. However, the raw assessing needs some time, thus, we provide a preprocessed in the data folder.

To identify the homogeneous subgroups of the dataset, a penalized approach based on a regression model was proposed to deal with this heterogeneous group, in which heterogeneity is driven by unobserved latent factors and thus can be represented by subject-specified intercepts. Applying a concave penalty(MCP) to both the pairwise differences of the intercepts and coefficients, the procedure automatically divides observations into subgroups by the alternating direction method of the multiplier algorithm(ADMM).

## Code
### Abstract
All of tha data analysis for this report were done in R. The corresponding code is provided to take exploratory data analysis on the raw data, perform preprocessing steps and generate descriptive plots applied to the report(this three parts were represented on the final report); The other main code are also pubilshed to conduct tuning parameters selection through BIC or cross-validation; direct subject-interceps and coefficients estimation by ADMM algorithm. Finally, some simulations are also shared.

### Description
All of the R scripts used in the report are available in a public repository on GitHub [https://github.com/yexiaoqingruc/yxqhomework](url). The MIT license applies to all codes, and no permissions are required to access codes. And some main results are displayed on the [https://yexiaoqingruc.shinyapps.io/shiny/ ](url). (For the ADMM algorithm is time-consuming, sometimes the shiny website is out of time. A more feasible version may be assess in the short future.)

### Optional Information

R version 3.5.1 was used for the analysis in this project. And the applications of shared codes are respectively: 

- **ADMM.R** is a function of conducting the ADMM algorithm to estimate the subject-specified intercepts and the coefficients. 

- **ST.R** is a soft-thresholding function and applied to the **ADMM.R**.

- **K.R** is a function of calculating the numbers of the subgroups automatically divided by the procedure. In this project, it is also applied to the **ADMM.R**.

- **Lam_Ome_opt_BIC.R** is a function carried out to selecte tuning parameters with BIC rule. **Lam_Ome_opt_CV.R** is used in the same way by cross-validation. **Lam_Ome_opt_BIC_para.R** is a parallel-version of **Lam_Ome_opt_BIC.R**, and it requires 30 idle nuclears. Users can change the core-numbers according to the ability of the server. In this project, the parallel-version with BIC rule is used for the accuracy and efficiency.

- **group_member.R** is a function to identify the subgoup members.

- **simulation.R** and **solution_path.R** are about simulations which are not required in this project, thus here we don't go into the details.

## Instructions for Use
### Reproducible
All data accessing, preprocessing and analyzing are reproduced. But the data the figures displayed in the report should be found in the final report and proposal.

The workflow information is contained in the **Reproducible_SA.R** script. The main general steps are:

1. Conducting tuning parameters selection;
2. Estimating the main parameters(subject-specified intercepts and coefficients) and dividing subgroups including obtaining the numbers of subgroup;
3. Identifying the members of all subgroups and analyzing the homogeneity in each subgroup and heterogeneity among subgroups.
