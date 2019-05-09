ST = function(z, lambda){
  ST = abs(z) - lambda
  ST = ST * (ST > 0)
  ST = sign(z) * ST
  return(ST)
}



