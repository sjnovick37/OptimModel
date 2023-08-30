\name{rout.fitter}
\alias{rout.fitter}
\title{Fit Model with ROUT}
\description{ Fit nonlinear model using ROUT method for outlier detection.  }
\usage{rout.fitter(theta0, f.model, x, y, tol=1e-3, Q=0.01, ...)
}
\arguments{
    \item{theta0}{ starting values.  Alternatively, if given as NULL, theta0 can be computed within rout.fitter()
        if a starting values function is supplied as attr(f.model, "start"), as a function of x and y. If theta0 is user supplied,
        the last entry of theta0 should be log(sigma), where sigma = residual standard deviation. Otherwise, log(sigma) will be
        estimated and appended to the results from attr(f.model, "start"). }
    \item{f.model}{ Name of mean model function. }
    \item{x}{ Explanatory variable(s).  Can be vector, matrix, or data.frame }
    \item{y}{ Response variable. }
    \item{tol}{ Tolerance for optim algorithm. }
    \item{Q}{ The test size for ROUT testing. }
    \item{...}{ Other arguments to passed to optim.  See ?optim.  For example, lower=, upper=, method=}
}
\details{
  rout.fitter() is a wrapper for optim(), specifically for Cauchy likelihood linear and non-linear regression.
  The Default algorithm uses method="BFGS" or "L-BFGS-B", if lower= and upper=
  are specified.  These can easily be overridden using the "...".
  
  
  The assumed model is:   y = f.model(theta, x) + sigma*Eps, where Eps~Cauchy(0, 1).
  

  After the Cauchy likelihood model is fitted to data, the residuals are interrogated to determine which observations
  might be outliers.  An FDR correction is made to p-values (for outlier testing) through the p.adjust(method="fdr") function of the stats package.

}
\value{

The returned object is a list with the following components and attributes:

  
par = estimated Cauchy model coefficients.  The last term is log(sigma)

value, counts, convergence = returns from optim()

message = character, indicating problem if any.  otherwise=NULL

hessian = hessian matrix of the objective function (e.g., sum of squares)

Converge = logical value to indicate hessian is positive definite


call = rout.fitter() function call

residuals = model residuals

rsdr = robust standard deviation from ROUT method

sresiduals = residuals/rsdr

outlier = logical vector.  TRUE indicates observation is an outlier via hypothesis testing with unadjust p-values.

outlier.adj = logical vector.  TRUE indicates observation is an outlier via hypothesis testing with FDR-adjust p-values.

attr(object, "Q") = test size for outlier detection


}
\examples{
set.seed(123)

x = rep( c(0, 2^(-4:4)), each=4 )
theta = c(0, 100, log(.5), 2)
sigma = 2
y = hill.model(theta, x) + rnorm( length(x), sd=sigma )

rout.fitter(NULL, hill.model, x=x, y=y)
rout.fitter(c( theta, log(sigma) ), hill.model, x=x, y=y)

ii = sample( 1:length(y), 2 )
y[ii] = hill.model(theta, x[ii]) + 5.5*sigma + rnorm( length(ii), sd=sigma )

rout.fitter(c( theta, log(sigma) ), hill.model, x=x, y=y, Q=0.01)
rout.fitter(c( theta, log(sigma) ), hill.model, x=x, y=y, Q=0.05)
rout.fitter(c( theta, log(sigma) ), hill.model, x=x, y=y, Q=0.0001)

  ## Use optim method="L-BFGS-B"
rout.fitter(NULL, hill.model, x=x, y=y, Q=0.01, lower=c(-2, 95, NA, 0.5), upper=c(5, 110, NA, 4) )

}
\author{Steven Novick}
\keyword{Nonlinear}