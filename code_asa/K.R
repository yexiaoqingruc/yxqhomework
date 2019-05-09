estimation_K=function(eta, n){
  seq = 1 : n
  K = 1
  
  while(length(seq) > 0)
  {
    i = seq[1]
    index = (i - 1) * n - i * (i - 1) / 2
    pos = which(eta[(index + 1) : (index + n - i)] == 0)   ####go back to the position
    pos = c(i, i + pos)
    seq = seq [! seq %in% pos]                                ###leave the value pos out
    K = K + 1
  }
  K = K - 1
  return(K)
}
