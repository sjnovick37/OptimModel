# Program:  rout.fitter.R
# Version:  1
# Author:   Steven Novick
# Date:     July 3, 2003
# Purpose:  Perform the Robust Outlier (ROUT) Detection method of Motulsky and Brown (2006)


# Motulsky HJ, Brown RE. Detecting outliers when fitting data with nonlinear regression - a new method based on robust nonlinear regression and the false discovery rate.
# BMC Bioinformatics. 2006 Mar 9;7:123. doi: 10.1186/1471-2105-7-123. PMID: 16526949; PMCID: PMC1472692.

rout.fitter = function( theta0=NULL, f.model, x, y, lbs=FALSE, ntry=0, tol=1e-3, Q=0.01, ... )
{

 ## theta0: (optional) starting value.  If is.null(theta0), then theta0 is calculated from attr(f.model, "start") = function(x, y)
 ##          If provided, the last entry of theta0 should be log(sigma), where sigma = residual standard deviation.
 ##          Otherwise, log(sigma) is automatically calculated and appended to attr(f.model, "start").
 ## f.model: yields the mean value of Y as a function of theta and x.
 ## x: dependent variable(s) in the model
 ## y: response variable
 ## lbs:  log both sides

 cl = match.call()
 if ( nrow( as.matrix(x) ) != length(y) )
    stop("Number of observations in 'x' must equal number of observations in 'y'.")

  ## Check data integrity
 if ( any(is.na(x)) || any(is.na(y)) )
    warning("Missing values in your data may cause rout.fitter() to fail.")

 optim.list = .get.optim.args( list(...), tol )

 N = length(y)
 y.orig = y
 if ( lbs )
   y = log(y.orig)

 ## Get starting values
 if ( is.null(theta0) )
 {
    theta0 = attr(f.model, "start")(x, y.orig)
    mu= f.model(theta0, x)
    if ( lbs )
      mu = log(mu)

    res0 = y - mu
    rsdr0 = quantile( abs(res0), 0.6827 )*N/( N-length(theta0) )
    theta0 = c(theta0, lsig=log(rsdr0))
 }

 ## Add n.try more starting values in a neighborhood of theta0
 ## Determine the best starting values based on the negative log-likelihood for Cauchy regression
 theta00 = t(theta0)

 if ( ntry > 0 )
 {

   M = pmax( 0.1*abs(theta0), 0.1 )

   theta00 = rbind(theta0,
                sapply(1:length(theta0), function(i){ rnorm(1000, mean=theta0[i], sd=M[i]) })
                )
   nlogL = apply(theta00, 1, function(th){  nlogLik.cauchy( th, x=x, y=y, f.model=f.model, lbs ) })
   theta00 = theta00[order(nlogL),]
 }
 ## Fit the model using the best of the starting values

 for ( i in 0:ntry )
 {

   fit = try( optim( theta00[i+1,], nlogLik.cauchy, f.model=f.model, lbs=lbs,
              method=optim.list$method, lower=optim.list$lower, upper=optim.list$upper, hessian=TRUE,
              x=x, y=y, control=optim.list$control.list)  )

   fit$Converge = test.fit( fit )
   if (fit$Converge)
     break
 }

  if ( fit$converge > 0 )
   warning("OLS:  optim failed to converge")

  ## calculate robust standard deviation (RSDR), residuals, and robust standardized residuals (sresiduals)
  mu = f.model(fit$par, x)
  if ( lbs )
    mu = log(mu)
  fit$fitted = mu
  fit$residuals = y - mu
  fit$rsdr = quantile( abs(fit$residuals), 0.6827 )*N/( N-length(fit$par)+1 )
  fit$sresiduals = fit$residuals/fit$rsdr

  fit$call = cl
  class(fit) = c("rout.fit", "list")

  if ( class(fit)[1] != "try-error" )
  {
    fit = rout.outlier.test( fit, Q=Q )
    ii = !fit$outlier
    ssto = sum( (y[ii]-mean(y[ii]))^2 )
    sse = sum( (y[ii]-mu[ii])^2 )
    fit$r.squared = as.vector( (ssto-sse)/ssto )

    ii = !fit$outlier.adj
    ssto = sum( (y[ii]-mean(y[ii]))^2 )
    sse = sum( (y[ii]-mu[ii])^2 )
    fit$r.squared.adj = as.vector( (ssto-sse)/ssto )

  }

  return(fit)

}
