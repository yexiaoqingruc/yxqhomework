Lamb_Ome_opt_CV = function(X, y, group = 2, lamb_lower = 0.2,
                           lamb_upper = 1, ome_lower = 0.2, 
                           ome_upper = 1, grid_num_lam = 10, grid_num_ome = 10){
  library(dplyr)
  ##auxiliary function
  f_minus = function(p_1){
    p_1 - y_omi
  }
  
  data = cbind(y, X)
  gr_num = nrow(data) / group
  Lam = seq(lamb_lower, lamb_upper, length = grid_num_lam)
  Ome = seq(ome_lower, ome_upper, length = grid_num_ome)
  Error_pred = matrix(NA, nrow = grid_num_lam, ncol = grid_num_ome)
  for(i in 1 : grid_num_lam){
    for(j in 1 : grid_num_ome){
      lambda = Lam[i]; omega = Ome[j]
      Y_pred = matrix(NA, nrow = gr_num * (group - 1), ncol = group)
      for (k in 1 : group) {
        data_omi = data[-((1 + (k - 1) * gr_num) : (k * gr_num)), ]
        y_omi = data_omi[, 1]; x_omi = data_omi[, -1]
        
        result = estimationADMM(x_omi, y_omi, lambda, omega)
        
        beta_opt = result[[3]] %>% as.vector
        mu_opt = result[[2]] %>% as.vector
        y_pred = mu_opt + x_omi %*% beta_opt
        Y_pred[, k] = y_pred
      }
      temp = Y_pred %>% apply(1, mean) %>% f_minus %>% crossprod %>% sqrt
      Error_pred[i, j] = temp / length(y_omi) %>% as.numeric
      print(paste("i,j =", i,j))
    }
  }
  min_Error_pred = Error_pred %>% min
  position = which(Error_pred == min_Error_pred, arr.ind = T) %>% as.numeric
  lambda_opt = Lam[position[1]]
  omega_opt = Ome[position[2]]
  
  return(list(lambda_opt, omega_opt))
}

