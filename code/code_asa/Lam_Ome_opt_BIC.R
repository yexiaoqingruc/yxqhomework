Lam_Ome_opt_BIC = function(x, y, vartheta = 1, gamma = 3, c = 5, 
                           lambda_upper = 1, lambda_lower = 0.2, 
                           omega_upper = 1.2, omega_lower = 0.4, 
                           grid_num_lam = 5, grid_num_ome = 5){
  n = nrow(x)
  lamb = seq(lambda_lower, lambda_upper, length = grid_num_lam)
  ome = seq(omega_lower, omega_upper, length = grid_num_ome)
  
  BIC = matrix(-1, grid_num_lam, grid_num_ome)
  for(i in 1 : grid_num_lam){
    for(j in 1 : grid_num_ome){
      lambda = lamb[i]
      omega = ome[j]
      result = estimation_ADMM(x, y, lambda, omega)
      muhat = result[[2]]
      K = result[[1]]
      betahat = result[[3]]
      df = K + ncol(x)
      Q = t(y - muhat - x %*% betahat) %*% (y - muhat - x %*% betahat) / n
      Q = Q[1,1]
      BIC[i, j] = log(Q) + c * log(log(n + ncol(x))) * log(n) * df / n
      print(BIC[i, j])
      print(paste("i=", i))
      print(paste("j=", j))
      print(paste("lambda=", lamb[i], "omega=", ome[j]))
    }
  }
  
  BIC_min = BIC %>% apply(2, min) %>% min
  pos = which(BIC == BIC_min, arr.ind = T)

  lambda_opt = lamb[pos[1]]
  omega_opt =ome[pos[2]]
  
  return(list(lambda_opt, omega_opt, BIC))
}
