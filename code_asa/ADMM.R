estimation_ADMM = function(x, y, lambda, omega, gamma = 3, vartheta = 1){
  library(ncvreg); library(dplyr)
  dx = ncol(x)
  n = nrow(x)
  beta_ini = runif(dx, 0.5, 1)
  mu_ini = y - x %*% beta_ini
  eta_ini = seq(0, 0, length = (n * ( n - 1 ) / 2))
  delta = matrix(0, nrow = n, ncol = (n * (n - 1) / 2))
  e = diag(n)
  for(i in 1 : (n - 1)){
    index = (i - 1) * n - i * (i - 1) / 2
    eta_ini[(index + 1) : (index + n - i)] = mu_ini[i] - mu_ini[(i + 1) : n]
    delta[ , (index + 1) : (index + n - i)] = e[ , i] - e[ , (i + 1) : n]
  }
  delta = t(delta)
  nu_ini = seq(0, 0, length = (n * (n - 1) / 2))
  
  mu_old = mu_ini
  beta_old = beta_ini
  eta_old = eta_ini
  nu_old = nu_ini
  
  eps = 1e-3
  step = 0
  r_old = 2
  En = diag(n)
  
  lam1 = lambda / vartheta
  while(r_old > eps){
    step = step + 1
    
    mu_part_1 = (En + vartheta * t(delta) %*% delta) %>% solve
    mu_part_2 = (vartheta * t(delta) %*% eta_old - t(delta) %*% nu_old + y - x %*% beta_old)
    mu_new = mu_part_1 %*% mu_part_2
    
    fit = ncvreg(x, y - mu_new, family = "gaussian", penalty="MCP", lambda=c(lambda), convex=F, dfmax=dx, returnx=FALSE)
    beta_new = fit$beta[-1, ]
    #be_st = n ^ (-1) * t(x) %*% (y - mu_new)
    #beta = ST( be_st, omega )
    #beta_part = beta / (1 - 1 / gamma)
    #beta_new = beta_part * ( abs( be_st) <= gamma * omega ) + be_st * ( abs( be_st ) > gamma * omega)
    
    del = delta %*% mu_new + (1 / vartheta) * nu_old
    
    #eta=abs(del)-lam1
    #eta=eta*(eta>0)
    #eta=sign(del)*eta
    eta = ST(del, lam1)
    eta_new = (eta / (1 - (vartheta * gamma) ^ (-1))) * (abs(del) <= (gamma * lambda)) + 
      del * (abs(del) > (gamma * lambda)) 
    
    nu_new = nu_old + vartheta * (delta %*% mu_new - eta_new)
    
    r_new = (delta %*% mu_new - eta_new) %>% crossprod %>% as.numeric %>% sqrt
    # r_new_mu = (delta %*% mu_new - eta_new) %>% crossprod %>% as.numeric %>% sqrt
    # r_new_beta = (beta_old - beta_new) %>% crossprod %>% as.numeric %>% sqrt
    # r_new = (r_new_beta + r_new_mu) / 2
    
    r_old = r_new
    mu_old = mu_new
    beta_old = beta_new
    eta_old = eta_new
    nu_old = nu_new
    #print(paste("step=", step, "rold=", r_old ))
  }
  
  K = estimation_K(eta = eta_old, n)
  
  
  return(list(K, mu_old, beta_old, eta_old, step))
  
}




