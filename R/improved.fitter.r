# Program:  improved.fitter.R
# Version:  1
# Author:   Steven Novick
# Date:     July 3, 2003
# Purpose:  Calls optim.fit() with different starting values across a fixed or random grid

improved.fitter = function( theta0, f.model, x, y, wts,
                            Mult=0.1, n.start=1000, max.try=25, start.method=c("fixed", "random"), until.converge=FALSE, keep.all=FALSE, ... )
{

  ## theta0 = starting parameter values
  ## f.model = model function to be fitted, of the form function(theta, x).
  ## x, y, wts = explanatory variable(s), response variable, and (optionally) weights
  ## Mult = numeric multiplier, single # or vector of length(theta), to set distance
  ##        of the grid of starting values from theta0
  ## n.start, max.try = number of starting values.  Each starting values is evaluated via weighted sums of squared errors.
  ##                    Only the best max.try starting values are feed into optim.fit()
  ## start.method = fixed or random grid of starting values.  Fixed is preferred when the # of parameters is small.
  ##                and random is preferred when the # of parameter is large.
  ## until.converge = logical.  Try every starting value (FALSE)? Or stop when convergence is reached (TRUE)?
  ## keep.all = logical. Keep all model fits from every starting value?
  ## ... = parameters passed to optim()


  cl = match.call()
  if ( is.null(theta0) )
    theta0 = attr(f.model, "start")(x, y)

  w = rep(1, length(y))
  if ( !missing(wts) && is.numeric(wts) )
  {
    if ( length(wts) != length(y) )
      stop("Number of weight values in 'weights' must equal number of observations in 'y'.")
    w = wts
  }

 M = pmax( Mult*abs(theta0), 0.1 )
 start.method = match.arg(start.method)

 if ( start.method=="fixed" )
 {
   theta00 = rbind(theta0,
               expand.grid(lapply(1:length(theta0), function(i){ seq( theta0[i]-3*M[i], theta0[i]+3*M[i], length=ceiling(n.start^(1/length(theta0)))) }))
               )
 }else{
   theta00 = rbind(theta0,
              sapply(1:length(theta0), function(i){ rnorm(n.start-1, mean=theta0[i], sd=M[i]) })
              )
 }
 colnames(theta00) = names(theta0)

 sumSq = apply(theta00, 1, function(th){  sum( w*(y-f.model(th, x))^2 ) })
 theta00 = theta00[order(sumSq),]

 if ( max.try > nrow(theta00) )
   max.try = nrow(theta00)

 fit = list()
 i.best = 1
 bic.lag = Inf
 for ( i in 1:max.try )
 {
   txt = paste("try( optim.fit( theta00[i,], ", match.call()$f.model, ", x=x, y=y, wts=", match.call()$wts, ", ... ), silent=TRUE )")
   fit[[i]] = eval( parse(text=txt) )
   fit[[i]]$Converge = FALSE

   if ( class(fit[[i]])[1] != "try-error" )
   {
     fit[[i]]$Converge = fit[[i]]$converge==0 & (class( try( chol(fit[[i]]$hessian), silent=TRUE ) )[1] == "matrix")
     fit[[i]]$call$theta0 = theta00[i,]
     for ( v in names(list(...)) )
       fit[[i]]$call[[v]] = list(...)[[v]]
   }
   else
     fit[[i]]$bic = Inf

   ## best fit
   if ( fit[[i]]$bic < bic.lag )
   {
     i.best = i
     bic.lag = fit[[i]]$bic
   }
   if ( until.converge & fit[[i]]$Converge )
   {
     fit = fit[1:i]
     i.best = i
     break
   }
 }
 if ( !keep.all )
   fit = fit[[i.best]]

  return(fit)

}
