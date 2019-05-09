#===============================================================
# Subgroup Analysis with the Ovary dataset
# [Xiaoqing Ye]
# May, 2019
#===============================================================

#===============================================================
# Reproducibility: Reproducible_SA script
#===============================================================

# This file contains instructions for reproducing the data, all
# analyses in the report.

# Download the repository from  GitHub [https://github.com/yexiaoqingruc/yxqhomework].
# The following script assumes the working directory has
# been set to this folder.

# As denoted below, raw data assessing takes a relatively long time to run. As such, pre-
# processed data files are available for next analysis. Otherwise,
# codes represented in the final report.rmd file have been run, thus they are not reprodu
# -ced here.

#===============================================================
# Step 0: Download the raw data and install necessary packages;
#===============================================================
## This step is represented in the README.md file.
# Taking exploratory data analysis on the raw data and conducting preprocessing steps.
## These procedures are detailedly represented on the final report. We don't go to the details
## to avoid repeatability.

setwd("../data")
load(x_emp.RData)
load(y_emp.RData)
x_emp = x_emp[, 330 : 1030]

## Necessary packages
library(dplyr)
library(ggpubr)
library(reshape2)
library(plotly)
library(ggplot2)
library(gridExtra)
library(Amelia)

#===============================================================
# Step 1: Conducting tuning parameters selection.
#===============================================================

setwd("../code_asa")
source("Lam_Ome_opt_BIC_para.R")
lamome_opt = Lam_Ome_opt_BIC_para(x_emp, y_emp)
lambda_opt = lamome_opt[1] %>% as.numeric
omega_opt = lamome_opt[2] %>% as.numeric

#===============================================================
# Step 2: Estimating the main parameters(subject-specified inter-
# -cepts and cofficients) and dividing subgroups including obtain-
# -ing the numbers of subgroup;
#===============================================================

setwd("../code_asa")
source("ST.R")
source("K.R")
source("ADMM.R")
result = estimation_ADMM(x_emp, y_emp, lambda_opt, omega_opt)

K = result[[1]] %>% as.numeric ## the numbers of subgroup
mu = result[[2]] %>% as.numeric ## the subject-specified intercepts
beta = result[[3]] %>% as.numeric ## the cofficients
eta = result[[4]] %>% as.numeric


#===============================================================
# Step 3: Identifying the members of all subgroups and analysing
# the homogeneity in each subgroup and heterogeneity among sub-
# -groups. 
#===============================================================

setwd("../code_asa")
source("group_members.R")
grm = eta %>% group_member(n = length(y_emp))

nf = matrix(1 : K, ncol = 1)
layout.show(nf)
data_emp = cbind(y_emp, x_emp)
for(i in 1 : K){
  
  group_ser = grm[i, ] %>% na.omit 
  
  if(length(group_ser) > 5){
    
    group = data_emp[group_ser, ] %>% as.matrix
    group_mu = mu[group_ser[1]]
    res = (group[, 1] - group_mu - group[, -1] %*% beta) 
    %>% as.data.frame
    colnames(res) = "resi"
    
    p = ggplot(res_1, aes(x = resi_1, y = ..density..)) + 
      geom_histogram(fill = "cornsilk", colour = "grey60", size = 0.2) + 
      geom_density() + xlim(range(res))
    
    ggplotly(p)
  }
  
}


