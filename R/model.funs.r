.f.ssq = function(theta, x, y, w=NULL)
{
  if ( is.null(w) )
    return( sum( (y-f.model(theta, x))^2 ) )
  else
    return( sum( w*(y-f.model(theta, x))^2 ) )
}

## This is the gradient of .f.ssq wrt theta
## gr.model is the gradient of f.model wrt theta
.gr.ssq = function(theta, x, y, w=NULL)
{
  g = gr.model(theta, x)
  r = y-f.model(theta, x)
  if ( is.null(w) )
    return(-2*colSums(g*r))
  else
    return(-2*colSums(w*g*r))
}

## Used in the IRWLS algorithm to estimate variance parameters
.trkfunc = function(phi)
{
  n = length(mu)
  g = w.func(phi, mu)
  gdot = exp( mean( log(g) ) )
  s = sum( abs(resid)/g )
  trk = gdot*s

  return(trk)
}

## Try to minimize the log-likelihood
.loglik = function(theta, phi=0, lsigma=0)
{
  pred = f.model(theta, x)
  sigma = exp(lsigma)*w.func(phi, pred)
  out = -sum( dnorm(y, mean=pred, sd=sigma, log=TRUE) )

  return(out)
}

.f.mle = function(all.param)
{
  l = list(theta=all.param[1:p.th], lsigma=all.param[length(all.param)])
  if ( phi.fixed )
    l[["phi"]] = phi.start
  else if ( length(all.param) > p.th+1 )
    l[["phi"]] = all.param[(p.th+1):(length(all.param)-1)]

  return(do.call(".loglik", l))

}
