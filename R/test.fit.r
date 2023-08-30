test.fit = function(obj)
{
  ## 1. Test if optim() converged.  optim()$converge==0
  ## 2. Test if hessian matrix is positive definitive.
  ##    Positive definite <=> hessian can be decomposed by cholesky decomposition
  ##                      <=> parameters maximize the likelihood

  pass = FALSE
  if ( class(obj)[1] != "try-error" )
  {
    if ( obj$converge==0 & class( try(chol(obj$hessian), silent=TRUE) )[1] == "matrix" )
      pass = TRUE
  }
  return(pass)
}
