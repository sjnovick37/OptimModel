# Program:  optim.fit.R
# Version:  1
# Author:   Steven Novick
# Date:     July 3, 2003
# Purpose:  Fit a model to data via ordinary least squares (OLS),
#           weighted least squares (OLS + fixed weights),
#           iterative reweighted least squares (IRWLS),
#           or maximum likelihood estimation (MLE).

optim.fit = function(theta0, f.model, gr.model=NULL, x, y, wts,
            fit.method=c("ols", "irwls", "mle"),
            var.method=c("hessian", "normal", "robust"),
            phi0=NULL, phi.fixed=TRUE, conf.level=.95, tol=1e-3, ...)
{

  ## theta0 = starting values for f.model()
  ## f.model = mean model of the form function(theta, x)
  ## gr.model = gradient of f.model wrt theta. All models inside this
  ##            library have an analytical gradient as an attribute
  ## x, y = explanatory variable(s) and response variable
  ## wts = (optional) can be a numeric vector of fixed weights or a function of the form function(phi, mu).
  ##       If wts is given as a function, then IRWLS or MLE must be selected.
  ## var.method = method to calculate the variance-covariance matrix for the estimate of theta
  ## phi0 = (optional) starting values for the weights function
  ## phi.fixed = (optional) Is phi0 the user-given fixed value for the weights function (TRUE) or should phi be estimated (FALSE)?
  ## conf.level = confidence level for confidence intervals for theta
  ## tol = tolerance limit for optim(), depending on the algorithm. Default algorithm is "BFGS".
  ## ... = (optional) arguments to be passed to optim()


  cl = match.call()
  fit.method = match.arg(fit.method)      ## ols, irwls, mle
  var.method = match.arg(var.method)      ## hessian, normal, robust

  ## Get weights
  if ( missing(wts) )
  {
    w.func = weights.varIdent
    attr(w.func, "label") = "weights.varIdent"
    wts = rep(1, length(y))

  }
  else if ( is.numeric(wts) )
  {
    w.func = NA
    attr(w.func, "label") = "user.defined"
    if ( length(wts) != length(y) )
      stop("Number of weight values in 'weights' must equal number of observations in 'y'.")
  }
  else if ( class(wts)=="function" )
  {
    w.func = wts
    attr(w.func, "label") = deparse(cl$wts)
    wts = rep(1, length(y))
  }
  else
    stop("Weights ('wts') must be given as either numeric or a function (or left as missing).")

  if ( nrow( as.matrix(x) ) != length(y) )
    stop("Number of observations in 'x' must equal number of observations in 'y'.")

  ## Check data integrity
  if ( any(is.na(x)) || any(is.na(y)) || any(is.na(wts)) )
    warning("Missing values in your data may cause optim.fit() to fail.")

  ## Make smart decisions/warnings:
  if ( fit.method=="mle" && var.method!="hessian"  )
  {
    var.method="hessian"
    warning("MLE algorithm requires var.method='hessian'.  Switching var.method to 'hessian'.")
  }
  if ( fit.method=="ols" && !( attr(w.func, "label") %in% c("weights.varIdent", "user.defined") ) )
  {
    warning("Switching fit.method to irwls to accomodate choice of 'wts'.")
    fit.method = "irwls"
  }
  if ( fit.method=="irwls" && attr(w.func, "label") %in% c("weights.varIdent", "user.defined") )
  {
    warning("Switching fit.method to ols to accomodate choice of 'wts'.")
    fit.method = "ols"
  }
  if ( attr(w.func, "label") %in% c("weights.varIdent", "user.defined") && !is.null(phi0) )
  {
    warning("phi0 parameter is ignored when weights are numeric or 'weight.varIdent'.")
    phi.fixed=TRUE
  }
  if ( attr(w.func, "label") == "weights.tukey.bw" && fit.method!="irwls" )
  {
    warning("Switching fit.method to irwls to accomodate Tukey bi-weight algorithm.")
    fit.method = "irwls"
  }
  optim.list = .get.optim.args( list(...), tol )

  if ( is.null(gr.model) )  ## Maybe the gradient is an attribute of f.model
    gr.model = attr(f.model, "gradient")
  if ( is.null(theta0) )  ## Make a starting-values function is an attribute of f.model
    theta0 = attr(f.model, "start")(x, y)

  .f.ssq=eval(parse(text=deparse(.f.ssq)))
  .gr.ssq=eval(parse(text=deparse(.gr.ssq)))
  if ( is.null(gr.model) )
    .gr.ssq = NULL

  ## Fit OLS model.  If method != "ols", these are the starting values.
  fit = optim(theta0, fn=.f.ssq, gr=.gr.ssq, method=optim.list$method,
          lower=optim.list$lower, upper=optim.list$upper, hessian=TRUE,
          x=x, y=y, w=wts, control=optim.list$control.list)
  attr(fit, "weights") = wts

  if ( fit$converge > 0 )
    warning("OLS:  optim failed to converge")

  if ( fit.method=="irwls" )
    fit = .optim.fit.irwls(ols.fit=fit, f.model=f.model, gr.model=gr.model, phi0=phi0, phi.fixed=phi.fixed, x=x, y=y, w.func=w.func, optim.list=optim.list)
  if ( fit.method=="mle" )
    fit = .optim.fit.mle(ols.fit=fit, f.model=f.model, phi0=phi0, phi.fixed=phi.fixed, x=x, y=y, w.func=w.func, optim.list=optim.list)

  fit$fit.method = fit.method
  fit$var.method = var.method
  attr(fit, "w.func") = w.func
  fit$call = cl
  fit = .get.fit.stats(fit, x, y, conf.level)

  fit$call = cl
  class(fit) = c("optim.fit", "list")

  return(fit)
}


