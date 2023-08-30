\name{optim.fit}
\alias{optim.fit}
\title{Fit Model with optim}
\description{ Fit nonlinear model with optim.  Options are:  OLS, IRWLS, and MLE.  }
\usage{optim.fit(theta0, f.model, gr.model=NULL, x, y, wts, fit.method=c("ols", "irwls", "mle"),
    var.method=c("hessian", "normal", "robust"), phi0=NULL, phi.fixed=TRUE, conf.level=.95, tol=1e-3, ...)                      
}
\arguments{
    \item{theta0}{ starting values.  Alternatively, if given as NULL, theta0 can be computed within optim.fit()
        if a starting values function is supplied as attr(f.model, "start"), as a function of x and y.}
    \item{f.model}{ Name of mean model function. }
    \item{gr.model}{ If specified, name of the partial derivative of f.model with respect to its parameter argument.  If
            not specified, f2djac will approximate the derivative.  Alternatively, the gradient of f.model can
            be specified as attr(f.model, "gradient") }
    \item{x}{ Explanatory variable(s).  Can be vector, matrix, or data.frame }
    \item{y}{ Response variable. }
    \item{fit.method}{ "ols" for ordinary least squares, "irwls" for iterative re-weighted least squares, "mle" for
            maximum likelihood. }
    \item{wts}{ Can be a numeric vector or a function.  Functions supplied are weights.varIdent, weights.tukey.bw,
              weights.varExp, weights.varPower, and weights.varConstPower. }
    \item{var.method}{ Method to compute variance-covariance matrix of estimated model parameters.  Choices are "hessian" to
        use the hessian inverse, "normal" to use the so-called 'folk-lore' theorem estimator, and "robust" to use a
        sandwich-variance estimator.  When fit.method="mle", var.method="hessian" and cannot be overridden. }
    \item{phi0}{ Not meaningful for fit.method="ols".  Starting value(s) for variance parameters (for weights). }
    \item{phi.fixed}{ Not meaningful for fit.method="ols".  If set to TRUE, the variance parameter(s) remain fixed at.  
        the given starting value, phi0.  Otherwise, the variance parameter(s) are estimated. }
    \item{conf.level}{ Confidence level of estimated parameters. }
    \item{tol}{ Tolerance for optim algorithm. }
    \item{...}{ Other arguments to passed to optim.  See ?optim.  For example, lower=, upper=, method=}
}
\details{
  optim.fit() is a wrapper for optim(), specifically for non-linear regression.
  The Default algorithm is ordinary least squares (ols) using method="BFGS" or "L-BFGS-B", if lower= and upper=
  are specified.  These can easily be overridden.
  
  
  The assumed model is:   y = f.model(theta, x) + g(theta, phi, x)*sigma*Eps, where Eps~N(0, 1).  Usually g() = 1.
  
  With the exception of weights.tukey.bw, the weights functions are equivalent to g(theta, phi, x).
  
  \bold{Algorithms}:
  
  1.  OLS.   Minimize  sum(  (y - f.model(theta, x))^2 )
  
  2.  IRWLS. Minimize sum( g(theta, phi, x)*(y - f.model(theta, x))^2 ), where g(theta, phi, x) act as weights.  See section
      on Variance functions below for more details on g().
      
  3.  MLE.   Minimize the -log(Likelihood).  See section on Variance functions below for more details on g().

      
  \bold{Variance functions}:
  
  Weights are given by some variance function.  Some common variance functions are supplied.
  
  See weights.varIdent, weights.varExp, weights.varPower, weights.varConstPower.
  

  User-specified variance functions can be provided for weighted regression.
  
}
\value{

The returned object is a list with the following components and attributes:

  
coefficients = estimated model coefficients

value, counts, convergence = returns from optim()

message = character, indicating problem if any.  otherwise=NULL

hessian = hessian matrix of the objective function (e.g., sum of squares)

fit.method = chosen fit.method (e.g., "ols")

var.method = chosen var.method (e.g., "hessian")

call = optim.fit() function call

fitted, residuals = model mean and model residuals

r.squared, bic = model statistics

df = error degrees of freedom = N - p, where N = # of observations and p = # of parameters

dims = list containing the values of N and p

sigma = estimated standard deviation parameter

varBeta = estimated variance-covariance matrix for the coefficients

beta = data.frame summary of the fit


attr(object, "weights") = weights

attr(object, "w.func") = weights model for the variance

attr(object, "var.param") = variance parameter values

attr(object, "converge.pls") = logical indicating if IRWLS algorithm converged.

}
\examples{
set.seed(123)

x = rep( c(0, 2^(-4:4)), each=4 )
theta = c(0, 100, log(.5), 2)
y1 = hill.model(theta, x) + rnorm( length(x), sd=2 )
y2 = hill.model(theta, x) + rnorm( length(x), sd=.1*hill.model(theta, x) )
wts = runif( length(y1) )

fit1=optim.fit(theta, hill.model, x=x, y=y1)
fit2=optim.fit(theta, hill.model, x=x, y=y1, wts=weights.varIdent)
fit3=optim.fit(theta, hill.model, x=x, y=y1, wts=wts)
fit4=optim.fit(theta, hill.model, attr(hill.model, "gradient"), x=x, y=y1, wts=wts)

fit5=optim.fit(NULL, hill.model, x=x, y=y2, wts=weights.varPower, fit.method="irwls")
fit6=optim.fit(theta, hill.model, x=x, y=y2, wts=weights.varPower, fit.method="mle")

fit7=optim.fit(theta, hill.model, x=x, y=y2, wts=weights.varPower, fit.method="irwls", phi0=0.5, phi.fixed=FALSE)
fit8=optim.fit(theta, hill.model, x=x, y=y2, wts=weights.varPower, fit.method="mle", phi0=0.5, phi.fixed=FALSE)

fit9=optim.fit(theta, hill.model, x=x, y=y1, wts=weights.tukey.bw, fit.method="irwls", phi0=4.685, phi.fixed=TRUE)

}
\author{Steven Novick}
\keyword{Nonlinear}