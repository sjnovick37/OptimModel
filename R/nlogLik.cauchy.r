# Program:  nlogLik.cauchy.R
# Version:  1
# Author:   Steven Novick
# Date:     July 3, 2003
# Purpose:  negative log-likelihood for Cauchy model fit

nlogLik.cauchy = function(theta, x, y, f.model, lbs)
{
  ## Negative log likelihood for Cauchy distribution of y | x
  ## theta:  vector of parameters.
  ##    Location parameter for Cauchy is f.model(theta[1:(length(theta)-1)], x)
  ##    Scale parameter is exp( theta[ length(theta) ] )
  p = length(theta)
  mu = f.model(theta[1:(p-1)], x)
  if ( lbs )
    mu = log(mu)
  sigma = exp(theta[p])
  nlogL = -sum( dcauchy( y, location=mu, scale=sigma, log=TRUE ) )
  return(nlogL)
}
