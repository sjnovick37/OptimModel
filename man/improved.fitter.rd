\name{improved.fitter}
\alias{improved.fitter}
\title{Fit Model with optim with prior optimization}
\description{ Fit nonlinear model with optim with prior optimization.  Options are:  OLS, IRWLS, and MLE.  }
\usage{improved.fitter(theta0, f.model, x, y, wts,
                            Mult=0.1, n.start=1000, max.try=25, until.converge=FALSE, ...)
}
\arguments{
    \item{theta0}{ starting values.  Alternatively, if given as NULL, theta0 can be computed with improved.fitter()
        if a starting values function is supplied as attr(f.model, "start"), as a function of x and y.}
    \item{f.model}{ Name of mean model function. }
    \item{x}{ Explanatory variable(s).  Can be vector, matrix, or data.frame }
    \item{y}{ Response variable. }
    \item{wts}{ Optional.  Can be a numeric vector or a function.  Functions supplied are weights.varIdent, weights.tukey.bw,
              weights.varExp, weights.varPower, and weights.varConstPower. }
    \item{Mult}{ Neighborhood for random starting values (see details). }
    \item{n.start}{ Number of starting values to generate (see details). }
    \item{max.try}{ Maximum number of calls to optim.fit(). }
    \item{until.converge}{ Logical (TRUE/FALSE) indicating when algorithm should stop. }
    \item{keep.all}{ Logical (TRUE/FALSE) indicating whether to keep all modelled fits (TRUE) or return the best fit (FALSE). }
    \item{...}{ Other arguments to passed to optim.fit.  See details and ?optim.fit.  }
}
\details{
  improved.fitter() is a wrapper for optim.fit(), specifically for non-linear regression.  See optim.fit() for details.

  Starting value, theta0, is either supplied by the user or calculated via attr(f.model, "start") function.  The improved.fitter() will
  generate "n.start" additional starting values (retaining the original theta0 starting value) with an independent normal random variable
  with mean theta0[i] and standard deviation Mult*abs( theta0[i] ) or Mult[i]*abs( theta0[i] ), depending on whether Mult is given as a single
  value or a vector of values.  In all, there will be (n.start + 1) starting values to evaluate.

  The (n.start + 1) starting values are sorted by weighted least squares:  sum( w*(y-f.model(th, x))^2 ), where w = wts if wts are numeric.
  If weights are not supplied (wts) or are given as a function (e.g., weights.varPower), then w = 1.

  The function optim.fit() is then called with the best ordered max.try starting values passing the "..." arguments to optim.fit().  If
  until.converge=TRUE, the algorithm will stop when both fit$converge=0 (from "optim") and when the hessian matrix is positive definite.  Otherwise,
  optim.fit() will be called "max.tries" number of times and the fit with the smallest "bic" value will be returned.
  

}
\value{

The returned object is an optim.fit() object with one additional variable "Converge", indicating that "converge" = 0 (from "optim") and the hessian
matrix is positive definite.

}
\examples{
set.seed(123)

x = rep( c(0, 2^(-4:4)), each=4 )
theta = c(0, 100, log(.5), 2)
y1 = hill.model(theta, x) + rnorm( length(x), sd=2 )
y2 = hill.model(theta, x) + rnorm( length(x), sd=.1*hill.model(theta, x) )
wts = runif( length(y1) )

fit1=improved.fitter(theta, hill.model, x=x, y=y1)
fit2=improved.fitter(theta, hill.model, x=x, y=y1, wts=weights.varIdent)
fit3=improved.fitter(theta, hill.model, x=x, y=y1, wts=wts)
fit4=improved.fitter(NULL, hill.model, x=x, y=y1, wts=wts, until.converge=TRUE)

fit5=improved.fitter(NULL, hill.model, x=x, y=y2, wts=weights.varPower, fit.method="irwls")
fit6=improved.fitter(theta, hill.model, x=x, y=y2, wts=weights.varPower, fit.method="mle")

fit7=improved.fitter(theta, hill.model, x=x, y=y2, wts=weights.varPower, fit.method="irwls", phi0=0.5, phi.fixed=FALSE, until.converge=TRUE)
fit8=improved.fitter(theta, hill.model, x=x, y=y2, wts=weights.varPower, fit.method="mle", phi0=0.5, phi.fixed=FALSE)

fit9=improved.fitter(theta, hill.model, x=x, y=y1, wts=weights.tukey.bw, fit.method="irwls", phi0=c(sig=2, B=4.685), phi.fixed=TRUE)

fit10=improved.fitter(theta, hill.model, x=x, y=y2, wts=weights.varPower, fit.method="mle", phi0=0.5, phi.fixed=FALSE, keep.all=TRUE)
}
\author{Steven Novick}
\keyword{Nonlinear}