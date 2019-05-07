set.seed(100)
#library(doRNG)
#library(doSNOW)
vartheta = 1
nsim = 200
n = 100
p = 500
mux = rep(0, p)
Sigma = diag(p) + matrix(rep(0.3, p ^ 2), p, p) - diag(0.3, p)
epsi = rnorm(n, 0, 0.5 ^ 2)

###parallel to generate random numbers
#cl = makeCluster(4)
#registerDoSNOW(cl)
#set.seed(123)
#x = foreach(i=1:n, .combine = "rbind", .packages = "MASS") %dorng% { mvrnorm(1, mux, Sigma) }
#stopCluster(cl)
x = mvrnorm(n, mux, Sigma)
bbeta = rep(NA, times = p)
smal_num = p - floor(4 * n / 5)
smal_pos = sample(1 : p, smal_num) %>% as.vector
bbeta[smal_pos] = runif(smal_num, 0, 0.2)
bbeta[-smal_pos] = runif(p - smal_num, 0.6, 1)
alpha = 5
u = runif(n)
mu = (u < 1 / 2) * alpha + (u >= 1 / 2) * (-alpha)
y = mu + x %*% bbeta + epsi

###plot a kernel density with fixed intercept
library(ncvreg); library(ggplot2)
cvfit = cv.ncvreg(x, y)
fit = cvfit$fit
beta_ncv = fit$beta[ ,cvfit$min]
beta_ncv = beta_ncv[-1]
res = y - beta_ncv[1] - x %*% beta_ncv
res = res %>% as.data.frame
colnames(res) = "resi"
ggplot(res, aes(x = resi, y = ..density..)) + 
  geom_histogram(fill = "cornsilk", colour = "grey60", size = 0.2) + 
  geom_density(size = 1) + xlim(-30, 30) +
  labs(x = "response variable", y = "Density")

gamma = 3

Ksim = seq(0,0,length = nsim)
MSEmu = seq(0,0,length = nsim)
MSEbeta=seq(0,0,length=nsim)

for(i in 1 : nsim){
  
  #lambome=Lamb_Ome_opt(x,y,group = 5)
  lambome = Lam_Ome_opt_BIC(x,y)
  lambda_opt = lambome[[1]]
  omega_opt = lambome[[2]]
  result = estimation_ADMM(x, y, lambda_opt, omega_opt)
  Khat = result[[1]]
  muhat = result[[2]]
  betahat = result[[3]]
  
  Ksim[i] = Khat
  MSEmu[i] = sqrt(t(muhat - mu) %*% (muhat - mu) / n)
  MSEbeta[i] = sqrt(t(betahat - bbeta) %*% (betahat - bbeta) / ncol(x))
  print(paste("i=", i))
}

list(Ksim, MSEmu, MSEbeta)

#Khat:mean/median/sd
summary(Ksim)
sd(Ksim)
#MSEmu/MSEbeta
MSEmu = mean(MSEmu)
MSEbeta = mean(MSEbeta)













