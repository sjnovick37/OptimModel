\name{hill5.model}
\alias{hill5.model}
\title{Five-parameter Hill model, gradient, starting values, and back-calculation functions}
\description{ Five-parameter Hill model, gradient, starting values, and back-calculation functions.  }
\usage{ 

        hill5.model(theta, x)

        attr(hill5.model, "gradient")(theta, x)
        
        attr(hill5.model, "start")(x, y)
        
        attr(hill5.model, "backsolve")(theta, y)
}
\arguments{
    \item{theta}{ Vector of five parameters:  (emin, emax, log.ic50, m, log.sym).  See details. }
    \item{x}{ Vector of concentrations for the five-parameter Hill model. }
    \item{y}{ Response variable. }
}
\details{
  The five parameter Hill model is given by:
  
  y = emin + (emax-emin)/( 1 + exp( m*log(x) - m*log.ic50) )^exp(log.sym)
  
  emin = minimum y value, emax = maximum y value, log.ic50 = log( ic50 ), m = shape parameter,
    and log.sym = log( symmetry parameter  ).

  Note:  ic50 is defined such that hill5.model(theta, ic50) = emin+(emax-emin)/2^exp(log.sym)
}
\value{
Let N = length(x).  Then

hill5.model(theta, x) returns a numeric vector of length N.

attr(hill5.model, "gradient")(theta, x) returns an N x 5 matrix.

attr(hill5.model, "start")(x, y) returns a numeric vector of length 5 with starting values for
(emin, emax, log.ic50, m, log.sym).

attr(hill5.model, "backsolve")(theta, y) returns a numeric vector of length=length(y).

}
\examples{
x = rep( c(0, 2^(-4:4)), each=4 )
theta = c(0, 100, log(.5), 2, log(10))
hill5.model(theta, x)
attr(hill5.model, "gradient")(theta, x)
attr(hill5.model, "start")(x, y)
attr(hill5.model, "backsolve")(theta, 50)
}
\author{Steven Novick}
\keyword{Nonlinear}
