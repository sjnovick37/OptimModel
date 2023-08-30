# Program:  predict.optim.fit.R
# Version:  1
# Author:   Steven Novick
# Date:     July 3, 2003
# Purpose:  Get predicted values, standard errors, confidence/prediction intervals from optim.fit()

predict.optim.fit = function (object, x, se.fit = FALSE,
                        interval = c("none", "confidence", "prediction"), K=1, level = 0.95)
{

  ## object = optim.fit() object
  ## x = explanatory variable(s) at which to make predictions
  ## se.fit = logical. Provide standard errors?
  ## interval, K = Can supply confidence interval or prediction interval for the next K observations
  ## level = confidence level

  interval = match.arg(interval)

  if ( missing(x) && (se.fit | interval!="none") )
    stop("User must provide 'x' for se.fit=TRUE or interval='confidence' or 'prediction'.")
  if ( interval != "none" )
    se.fit = TRUE


  f.model = eval(object$call$f.model)
  if ( missing(x) && interval=="none" )
    return( fitted(object) )

  out = list()
  if ( !missing(x) )
    out$x = x
  out$y.hat = f.model( coef(object), x )
  if ( se.fit )
  {
    jacobian = attr(f.model, "gradient")
    X.mat = if ( is.null(jacobian) )
                f2djac(f.model, coef(object), x=x)
              else
                jacobian(coef(object), x)
    var.y = diag(X.mat%*%object$varBeta%*%t(X.mat))
    out$se.fit = sqrt(var.y)
  }
  if ( interval != "none" )
  {
    sig = object$sigma
    if ( any( formalArgs(weights.varPower)=="mu" ) )    ## For the case:  Var( Y | x ) = sigma^2*g^2(mu, x)
      sig = sig*attr(object, "w.func")( attr(object, "var.param"), out$y.hat )

    se = sqrt( var.y + ifelse(interval=="confidence", 0, sig^2/K) )
    out$lower = out$y.hat - qt( (1+level)/2, object$df )*se
    out$upper = out$y.hat + qt( (1+level)/2, object$df )*se
  }

  return( do.call("cbind", out) )
}




