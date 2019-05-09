group_member = function(eta, n){
  seq = 1 : n
  gr = matrix(NA, nrow = 1, ncol = n)
  while(length(seq) > 0)
  {
    i = seq[1]
    index = (i - 1) * n - i * (i - 1) / 2
    pos = which(eta[(index + 1) : (index + n - i)] == 0)   ####go back to the position
    pos = c(i, i + pos)
    seq = seq [! seq %in% pos]                                ###leave the value pos out
    gr_temp = c(pos, rep(NA, times = n - length(pos)))
  }
  gr = rbind(gr, gr_temp)
  return(gr[-1, ])
}