# Program:  get.optim.args.R
# Version:  1
# Author:   Steven Novick
# Date:     July 3, 2003
# Purpose:  Internal functions to obtain extra arguments (the "...") for optim()
# This function is not visible to the user

.get.optim.args = function(object, tol)
{
  method = object$method               ## Which method of function optim(...)
  lower = -Inf
  upper = Inf

  if ( is.null(method) )
    method = ifelse(is.null(object$lower), "BFGS", "L-BFGS-B")
  if ( method == "L-BFGS-B" )             ## Put bounds on parameters.  bounds are only for estimate of theta
  {
    lower = object$lower
    upper = object$upper

    if ( (is.null(lower) | is.null(upper)) || (length(lower) != length(upper)) )
    {
      warning("User must specify both 'lower' and 'upper' (both of same length) to use optim method='L-BFGS-B'.\nSwitching to 'BFGS'.")
      method = "BFGS"
      lower=-Inf
      upper=Inf
    }
  }

  if ( method == "BFGS" )
    control.list = list(abstol=tol, maxit=200)
  else
    control.list = list(factr=tol/.Machine$double.eps, maxit=200)

  return( list( method=method, lower=lower, upper=upper, tol=tol, control.list=control.list ) )
}
