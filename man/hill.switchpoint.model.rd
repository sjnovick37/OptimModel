\name{hill.switchpoint.model}
\alias{hill.switchpoint.model}
\title{Five-parameter Hill model with switch point component, gradient, starting values, and back-calculation functions}
\description{ Five-parameter Hill model with switch point component, gradient, starting values, and back-calculation functions.  }
\usage{ 

        hill.switchpoint.model(theta, x)

        attr(hill.switchpoint.model, "gradient")(theta, x)
        
        attr(hill.switchpoint.model, "start")(x, y)
        
        attr(hill.switchpoint.model, "backsolve")(theta, y)
}
\arguments{
    \item{theta}{ Vector of five parameters:  (emin, emax, lec50, m, lsp).  See details. }
    \item{x}{ Vector of concentrations for the five-parameter Hill model with switch point component. }
    \item{y}{ Response variable. }
}
\details{
  The five parameter Hill model with switch point component is given by:
  
  y = emin + (emax-emin)/( 1 + exp( m*f(exp(lsp), x)*(log(x) - log.ic50) ) ), where
    emin = minimum y value, emax = maximum y value, log.ic50 = log( ic50 ), m = shape parameter, and f(s, x) is the switch point function.
    
  f(s, x) = (s-x)/(s+x) = 2/(1+x/s) - 1.  This function is contrained between -1 and +1 with s > 0.


  Notes:

  1.  At x=0, f(s, x) = 1, which reduces to hill.model(theta[1:4], 0).

  2.  The hill.switchpoint.model() is more flexible compared to hill.quad.model().
  
  3.  When the data does not contain a switchpoint, then lsp should be a large value so that f(exp(lsp), x) will be near 1 for all x.



}
\value{
Let N = length(x).  Then

hill.switchpoint.model(theta, x) returns a numeric vector of length N.

attr(hill.switchpoint.model, "gradient")(theta, x) returns an N x 5 matrix.

attr(hill.switchpoint.model, "start")(x, y) returns a numeric vector of length 5 with starting values for
(emin, emax, lec50, m, lsp).

Because hill.switchpoint.model() can be fitted to biphasic data with a hook-effect, attr(hill.switchpoint.model, "backsolve")(theta, y0) returns the first x that satisfies
y0=hill.switchpoint.model(theta, x)

}
\examples{
x = rep( c(0, 2^(-4:4)), each=3 )      ## Dose

  ## Create model with no switchpoint term
set.seed(123)
theta = c(0, 100, log(.5), 2)
y = hill.model(theta, x) + rnorm( length(x), mean=0, sd=5 )


  ## fit0 and fit return roughly the same r-squared and sigma values.
  ## Note that BIC(fit0) < BIC(fit), as it should be.
fit0 = optim.fit(NULL, hill.model, x=x, y=y)
fit = optim.fit(c(coef(fit0), lsp=0), hill.switchpoint.model, x=x, y=y)
fit = improved.fitter(NULL, hill.switchpoint.model, x=x, y=y)

  ## Generate data from hill.quad.model() with a biphasic (hook-effect) profile
xlog = log(x)
M = mean(xlog[ xlog > -Inf ])
z = xlog - M                           ## mean-centered log(Dose)

set.seed(123)
theta = c(0, 100, 2, 1, -0.5)          ## Model parameters
y = hill.quad.model(theta, z) + rnorm( length(z), mean=0, sd=5 )

  ## fit.qm and fit.sp return nearly identical fits
fit.qm = optim.fit(theta, hill.quad.model, x=z, y=y)  
fit.sp = improved.fitter(NULL, hill.switchpoint.model, x=x, y=y)  

plot(log(x+0.01), y)
lines(log(x+0.01), fitted(fit.qm))
lines(log(x+0.01), fitted(fit.sp), col="red")

  ## Generate data from hill.switchback.model()
set.seed(123)
theta = c(0, 100, log(0.25), -3, -2)
y = hill.switchpoint.model(theta, x) + rnorm( length(x), mean=0, sd=5 )
plot( log(x+0.01), y )

  ## Note that this model cannot be fitted by hill.quad.model()
fit = improved.fitter(NULL, hill.switchpoint.model, x=x, y=y)    
pred = predict(fit, x=exp(seq(log(0.01), log(16), length=50)), interval='confidence')

plot(log(x+0.01, y, main="Fitted curve with 95\% confidence bands")
lines(log(pred[,'x']+0.01), pred[,'y.hat'], col='black')
lines(log(pred[,'x']+0.01), pred[,'lower'], col='red', lty=2)
lines(log(pred[,'x']+0.01), pred[,'upper'], col='red', lty=2)


  ## Other functions
hill.switchpoint.model(theta, x)
attr(hill.switchpoint.model, "gradient")(theta, x)
attr(hill.switchpoint.model, "start")(x, y)
attr(hill.switchpoint.model, "backsolve")(theta, 50)

}
\author{Steven Novick}
\keyword{Nonlinear}
