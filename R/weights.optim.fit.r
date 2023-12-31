# Program:  weights.optim.fit.R
# Version:  1
# Author:   Steven Novick
# Date:     July 3, 2003
# Purpose:  Different weight functions for optim.fit()


weights.varIdent = function(phi, mu){ rep(1, length(mu)) }
weights.varExp = function(phi, mu){ exp(phi*mu) }
weights.varPower = function(phi, mu){ abs(mu)^(phi) }
weights.varConstPower = function(phi, mu){ abs( phi[1] + abs(mu)^phi[2] ) }
weights.tukey.bw = function(phi=4.685, resid)
{
  ## phi[1] = standard deviation, phi[2] = tuning constant (B=4.685), resid = model residuals
  sig = mad(resid, center=0)

  r = abs(resid)/sig
  wts = ifelse(r<=phi, (1-(r/phi)^2)^2, 0)
  return(wts)
}
weights.huber = function(phi=1.345, resid)
{
  ## phi = huber tuning constant, resid = model residuals
  sig = mad(resid, center=0)
  r = abs(resid)/sig
  wts = pmin(1, phi/r)

  return(wts)
}



