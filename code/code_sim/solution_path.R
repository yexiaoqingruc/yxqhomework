### alpha = 1; lambda = (0.2, 1), nlambda = 100, nomega = 100
nlambda = 200
nomega = 100
omega = 0.6
Lam = seq(0, 1, length = nlambda)
Ome = seq(0.5, 1, length = nomega)


MU = matrix(NA, nrow = length(y), ncol = nlambda)
f_MU = function(j){
  result = estimation_ADMM_mu(x, y, Lam[j], omega)
}
library(doSNOW)
library(doRNG)
cl = makeCluster(150)
registerDoSNOW(cl)
MU = foreach(j = 1:nlambda, .combine = "cbind") %dorng% estimation_ADMM_mu(x, y, Lam[j], omega)
stopCluster(cl)

plot(x = Lam, y = MU[1, ], type = "p", cex = 0.5, ylim = c(-10, 10))
for(p in 2 : nrow(MU)){
  points(y = MU[p, ], x = Lam, cex = 0.5, type = "p")
}
