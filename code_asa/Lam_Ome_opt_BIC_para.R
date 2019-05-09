Lam_Ome_opt_BIC_para = function(x, y, vartheta = 1, gamma = 3, c = 5, 
                           lambda_upper = 1, lambda_lower = 0.2, 
                           omega_upper = 1.2, omega_lower = 0.4, 
                           grid_num_lam = 10, grid_num_ome = 10){
  n = nrow(x)
  lamb = seq(lambda_lower, lambda_upper, length = grid_num_lam)
  ome = seq(omega_lower, omega_upper, length = grid_num_ome)
  
  LAM = rep(lamb, each = grid_num_ome)
  OME = rep(ome, times = grid_num_lam)
  
  library(doSNOW); library(doRNG); library(dplyr)
  core = grid_num_lam * grid_num_ome
  cl = makeCluster(25)
  registerDoSNOW(cl)
  #sfExportAll()
  
  BIC = NA
  BIC_seq = foreach(i = 1 : core, .combine = "c") %dorng% {
    print(paste("i=", i - 1, "BIC=", BIC))
    
    source("/home/yexiaoqing2017/Yexiaoqing/project_subgroup_analysis/code/ST.R")
    source("/home/yexiaoqing2017/Yexiaoqing/project_subgroup_analysis/code/K.R")
    source("/home/yexiaoqing2017/Yexiaoqing/project_subgroup_analysis/code/ADMM.R")
    
    lambda = LAM[i]
    omega = OME[i]
    result = estimation_ADMM(x, y, lambda, omega)
    muhat = result[[2]]
    K = result[[1]]
    betahat = result[[3]]
    df = K + ncol(x)
    Q = (t(y - muhat - x %*% betahat) %*% (y - muhat - x %*% betahat) / n) %>% as.numeric
    BIC = log(Q) + c * log(log(n + ncol(x))) * log(n) * df / n
    
  }
  
  stopCluster(cl)
  
  pos = which(BIC_seq == min(BIC_seq), arr.ind = T)
  
  rem = pos %% grid_num_ome
  
  if(rem == 0){pos_lam = pos %/% grid_num_ome; pos_ome = grid_num_ome}
  else{pos_lam = pos %/% grid_num_ome + 1; pos_ome = pos %% grid_num_ome}
  
  lambda_opt = lamb[pos_lam]
  omega_opt =ome[pos_ome]
  BIC_min = min(BIC_seq)
  
  return(list(lambda_opt, omega_opt, BIC_min))
}
